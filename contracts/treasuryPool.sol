// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
contract TreasuryPool is Initializable, UUPSUpgradeable,PausableUpgradeable, OwnableUpgradeable  {

function initialize() public initializer {
       __UUPSUpgradeable_init();
       __Ownable_init();
        __Pausable_init();
   }

function _authorizeUpgrade(address newContract) internal override onlyOwner {}



    event Recieved(string USD, address buyer, uint256 amount); // upon recieve there should be a mint

    event Redeemed(string USD, address redeemer, uint256 amount); // upon redeem there should be equal burn

    mapping(uint8 => address) public USDStable; // same implementation as liquidity pool for multi token.

    mapping(uint8 => string) public names; //name of token used

     function pause() public onlyOwner {
        _pause();

    }

    function unpause() public onlyOwner {
        _unpause();
    }


    //same as lp owner should give address of tokens after deployment
    //@TODO is  there a way that we define this array within a constructor to make sure that the contract is not deployed with no address of tokens
    function setUSDAddress (
        uint8 _index,
        string memory _name,
        address _USD
    ) public onlyOwner whenNotPaused {
        USDStable[_index] = _USD;
        names[_index] = _name;
    }

    // Tracks any addition of funds to thee pool and emits event received
    function Buy(uint8 _usd, uint256 _amount) public whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        IERC20Upgradeable(USDStable[_usd]).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        emit Recieved(names[_usd], msg.sender, _amount);
    }

    /**
     * @dev Owner Authorizes the user's redeem request
     */
    // upon redeem the money is sent to them and equivalent inrc is burnt
   function Redeem(address redeemer,uint8 _usd, uint256 _amount) public onlyOwner whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        IERC20Upgradeable(USDStable[_usd]).transfer(redeemer, _amount);
        emit Redeemed(names[_usd], redeemer, _amount);
    }
}