// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TreasuryPoolTron is Ownable ,Pausable {
    event Recieved( string USD, address buyer, uint256 amount); // upon recieve there should be a mint
    event USDCReciever( string USD, address buyer, uint256 amount);
    event Redeemed(string USD, address redeemer, uint256 amount); // upon redeem there should be equal burn

    mapping(uint8 => address) public USDStable; // same implementation as liquidity pool for multi token.
    mapping(uint8 => string) public names; //name of token used
     function unpause() public onlyOwner {
        _unpause();
    }

    function pause() public onlyOwner {
        _pause();
    }

    //same as lp owner should give address of tokens after deployment
    //@TODO is  there a way that we define this array within a constructor to make sure that the contract is not deployed with no address of tokens
    function setUSDAddress(
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
        IERC20(USDStable[_usd]).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        emit Recieved(names[_usd], msg.sender, _amount);
    }

    /**
     * @dev Owner Authorizes the user's redeem request
     */
 function BuyNat(string memory network)public payable whenNotPaused {
    require(msg.value > 0, "amount cannot be 0");
     network="TRON";
     emit Recieved(network, msg.sender,msg.value);
    }


    // upon redeem the money is sent to them and equivalent inrc is burntF
    function Redeem(uint8 _usd, uint256 _amount,address _redeemer) public onlyOwner whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        IERC20(USDStable[_usd]).transfer(_redeemer, _amount);
        emit Redeemed(names[_usd], _redeemer, _amount);
    }
}