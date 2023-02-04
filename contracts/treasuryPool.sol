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
/// @custom:oz-upgrades-unsafe-allow constructor
      constructor() {
        _disableInitializers();
    }
function _authorizeUpgrade(address newContract) internal override onlyOwner {}



 event Recieved(string USD,uint256 ID, address buyer, uint256 amount,uint256 balanceNew,uint256 UsdBalance); // upon recieve there should be a mint

    event Redeemed(string USD, address redeemer, uint256 amount,uint256 balanceNew,uint256 USDbalance); // upon redeem there should be equal burn

    mapping(uint8 => address) public USDStable; // same implementation as liquidity pool for multi token.

    mapping(uint8 => string) public names; //name of token used

        bool public Maxminted;
        bool public BuynatDisable;
        mapping(uint8=>uint256) public TPbalanceUSD;
        

        uint256 public tPtotalBalance;
        uint256 public tPtotalBalanceNative;

    /**
     * @dev Updates the address of the USD stable coins in the list
     */
function setMinter(bool _over)public onlyOwner whenNotPaused {
Maxminted=_over;
}
function setDisable(bool _disable)public onlyOwner whenNotPaused {
BuynatDisable=_disable;
}


     function pause() public onlyOwner {
        _pause();

    }

    function unpause() public onlyOwner {
        _unpause();
    }
    function setUSDAddress (
        uint8 _index,
        string memory _name,
        address _USD
    ) public onlyOwner whenNotPaused {
        USDStable[_index] = _USD;
        names[_index] = _name;
        
    }

    // Tracks any addition of funds to thee pool and emits event received
    function Buy(uint8 _usd, uint256 MintID,uint256 _amount) public whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        require (!Maxminted,"Maximum minting reached");
          TPbalanceUSD[_usd]+=_amount;
        tPtotalBalance += _amount;
        
        IERC20Upgradeable(USDStable[_usd]).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
      emit Recieved(names[_usd],MintID, msg.sender, _amount,tPtotalBalance,TPbalanceUSD[_usd]);
    }
     function BuyNat(uint256 MintID)public payable whenNotPaused {
     require(msg.value > 0, "amount cannot be 0");
     require (!Maxminted,"Maximum minting reached");
     require (!BuynatDisable,"Cannot buy using native coins anymore");
     string memory network="MATIC";
     tPtotalBalanceNative += msg.value;
     emit Recieved(network,MintID, msg.sender,msg.value,tPtotalBalance,tPtotalBalanceNative);
    }   

    /**
     * @dev Owner Authorizes the user's redeem request
     */
    // upon redeem the money is sent to them and equivalent inrc is burnt
   function Redeem(address redeemer,uint8 _usd, uint256 _amount) public onlyOwner whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        require(_amount<=TPbalanceUSD[_usd]);
        TPbalanceUSD[_usd]-=_amount;
         tPtotalBalance -= _amount;
        
        IERC20Upgradeable(USDStable[_usd]).transfer(redeemer, _amount);
         emit Redeemed(names[_usd], redeemer, _amount,tPtotalBalance,TPbalanceUSD[_usd]);
    }

     function RedeemNat(address redeemer, uint256 _amount) public payable onlyOwner whenNotPaused {
        require(_amount > 0, "amount cannot be 0");
        require (!Maxminted,"Maximum minting reached");
        require (!BuynatDisable,"Cannot buy using native coins anymore");
        require(_amount<=tPtotalBalanceNative);
        string memory network="MATIC";
        tPtotalBalanceNative -= _amount;
        
        payable(redeemer).transfer(_amount);
        emit Redeemed(network, redeemer, _amount,tPtotalBalance,tPtotalBalanceNative);
    }

    function getTPbalance(uint8 _length ) public view returns(uint256[] memory) {
     uint256[] memory Balances=new uint256[](_length);
for (uint8 i; i <_length ; i++)
{
    Balances[i]= TPbalanceUSD[i];
}
return Balances;

}

}
