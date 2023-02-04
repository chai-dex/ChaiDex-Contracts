// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract INRCoin is Initializable, ERC20Upgradeable,PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    event Issue(uint256 amount,address MintedTo);
    event Redeem(uint256 amount, address redeemer);
    mapping(uint256 => address) public BurnWhitelist;
    bool public epochover;
     function initialize() initializer public {
        __ERC20_init("INR Coin", "INRC");
        __Ownable_init();
        __Pausable_init();
        __UUPSUpgradeable_init();
    }
    /// @custom:oz-upgrades-unsafe-allow constructor
     constructor() {
        _disableInitializers();
    }
 function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
 function setBurnwhitelist (
        uint256 _index,
        address _burner
    ) public onlyOwner whenNotPaused  {
        BurnWhitelist[_index] = _burner;
    }
    function setEpoch(bool _over)public onlyOwner  whenNotPaused {
epochover=_over;
}
  function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return 2;
    }


    function issue(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount cannot be 0");
        _mint(to, amount);
        emit Issue(amount,to);
    }

    function redeem(uint256 amount,uint256 _id) public  {
        require(amount > 0, "Amount cannot be 0");
        require (epochover,"epoch not over");
        require(msg.sender==BurnWhitelist[_id], "Unauthorised");
        _burn(_msgSender(), amount);
        emit Redeem(amount, msg.sender);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

}