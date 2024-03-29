// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
contract EscrowERC is Initializable, UUPSUpgradeable, OwnableUpgradeable,PausableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;

     function initialize() public initializer {
       __UUPSUpgradeable_init();
       __Ownable_init();
       __Pausable_init();
   }

event tradeCreated (uint256 _Tradeid,address Seller,uint256 _amount);
event tradeCloneCreated (uint256 _TradeCloneid,address Seller);
event BuyerDeposit(uint256 _TradeCloneID,address Buyer,uint256 _amount);
event SwapComplete(uint256 _swapID,uint256 Parent,address Buyer);
event swapCreated(uint256 _SwapID,address Buyer);
event Sellerwithdraw(uint256 _TradeCloneid,address Seller,uint256 _amount);
event refunded(uint256 _Tradeid,address Seller,uint256 _amount);

/// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
   function _authorizeUpgrade(address newContract) internal override onlyOwner {}
 function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


    struct  TradeDetails{
        uint256 id;
        address seller;
        uint8 SellerGiveTokenIndex;
        uint256 endtime;
        uint256 DepositValue;
        uint256 AvailableValue;

    }

    struct TradeClone{
      uint256 id;
      address seller;
      uint8 SellerGetTokenIndex;
      uint256 endtime;
      uint256 MaxBalance;
      uint256 currentBalance;
       uint256 feeAmount;
    }

    struct SwapDetails{

        uint256 id;
        uint256 parentTradeID;
        address buyer;
        uint256 WithdrawAmount;
        uint256 feeAmount;
        bool CompletionStatus;
    }
  mapping(uint256 => TradeDetails) public TradeTrack;
  mapping(uint256 => TradeClone) public TradeCloneTrack;
  mapping(uint256 => SwapDetails) public SwapTrack;
  mapping(uint8 => string) public names;
  mapping(uint8 => address) public Whitelistedtokens;
  mapping(uint256 => bool) private TradeExisting;
  mapping(address=>mapping(uint256 => bool)) private SwapInProgress;
  mapping(uint256 => bool) private SwapExisting;
  mapping(uint256=>bool) private TradeUpdating;
  mapping(uint256=>bool) private TradeCloneUpdating;
  mapping(uint8=>uint256) public feeCollected;
   function setERCAddress(
        uint8 _index,
        string memory _name,
        address _token
    ) public whenNotPaused onlyOwner {
        Whitelistedtokens[_index] = _token;
        names[_index] = _name;
    }
    function setSwapID(uint256  _id,uint256 _parentID,address _buyer,uint256 _withdrawamount,uint256 _feeAmount)public onlyOwner whenNotPaused
    {
        require(!SwapExisting[_id],"swap still in progress");
        require(TradeExisting[_parentID],"Trade has ended or does not exist");
        require(_withdrawamount>0,"non zero values only");
        require(_withdrawamount>_feeAmount,"amount should be greater than fee");
        require(_buyer!=address(0),"invalid address");
        bool status=false;
        SwapDetails memory swapInfo = SwapDetails(
            _id,
            _parentID,
            _buyer,
            _withdrawamount,
            _feeAmount,
            status
        );
        SwapTrack[_id]= swapInfo;
        SwapExisting[_id]=true;
        emit swapCreated(_id,_buyer);
    }

    function setTradeCloneID(uint256 _id, address _seller ,uint256 _endtime,uint256 _maxAmount,uint8 _sellerTokenIndex,uint256 _feetoBepaid) public onlyOwner whenNotPaused
    {
        require(!TradeExisting[_id],"Trade clone already exists and in progress");
        require(_maxAmount>0,"non zero values only");
        uint256 _currentbalance=0;
       uint256 _Tradeclonetime=block.timestamp+_endtime;
        TradeClone memory CloneInfo = TradeClone(
            _id,
            _seller,
            _sellerTokenIndex,
            _Tradeclonetime,
            _maxAmount,
            _currentbalance,
            _feetoBepaid
        );
        TradeCloneTrack[_id]=CloneInfo;
        TradeExisting[_id]=true;
        emit tradeCloneCreated(_id,_seller);
    }

 function depositSeller(address _seller,uint256 _id,uint256 _amount,uint8 _tokenIndex,uint256 _endtime ) public  whenNotPaused{
require(msg.sender==_seller,"unauthorized");
require(!TradeExisting[_id],"trade already exists");
require(_amount>0,"Non zero values only");
require(_endtime>0,"Endtime must be greater");
uint256 _tradeTime=block.timestamp+_endtime;
  TradeExisting[_id]= true;
  TradeDetails memory data = TradeDetails(
         _id,
         _seller,
         _tokenIndex,
         _tradeTime,
         _amount,
         _amount


  );
  IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).safeTransferFrom(msg.sender,address (this), _amount);
   TradeTrack[_id] = data;
  emit tradeCreated(_id,_seller,_amount);
}

    function depositBuyer(uint256 _id, uint256 _amount) public whenNotPaused {
        require(_amount>0,"amount cannot be zero");
        require(TradeExisting[_id],"trade Does not exist");
        require(!TradeCloneUpdating[_id],"Please send transaction in some time");
        TradeCloneUpdating[_id]=true;

        require(!SwapInProgress[msg.sender][_id],"you can only opt for a trade once");
        SwapInProgress[msg.sender][_id]=true;
        TradeClone memory data = TradeCloneTrack[_id];
        require(data.seller!=address(0),"this trade does not exist");
        address seller=data.seller;
        require(msg.sender!=seller,"seller cant buy");
        require((data.currentBalance+_amount)<(data.MaxBalance),"The trade no longer has funds");
        require(block.timestamp<data.endtime,"This trade has ended");
         uint8 _tokenIndex=data.SellerGetTokenIndex;
         uint256 FeeTranfer=data.feeAmount;
         uint256 transferAmount=_amount-FeeTranfer;
         require(_amount>FeeTranfer,"amount too low");
         if(FeeTranfer!=0)
         {
              IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).safeTransferFrom(msg.sender,address(this), FeeTranfer);
               feeCollected[_tokenIndex]+=FeeTranfer;
              data.feeAmount=0;
         }

        data.currentBalance +=(_amount);
        TradeCloneTrack[_id]= data;
        IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).safeTransferFrom(msg.sender,seller, transferAmount);
        TradeCloneUpdating[_id]=false;
        emit BuyerDeposit(_id,msg.sender,_amount);
    }

    function withDrawBuyer(uint256 _id) public whenNotPaused{

        require(SwapExisting[_id],"swap does not exist");
        SwapExisting[_id]=false;
        SwapDetails memory data = SwapTrack[_id];
        require(data.WithdrawAmount>0,"withdraw completed");
        uint256 _parentID=data.parentTradeID;
        require(!TradeUpdating[_parentID],"Please send transaction in some time");
        TradeUpdating[_parentID]=true;
        uint256 amount=data.WithdrawAmount-data.feeAmount;
        address  _buyer=data.buyer;
        require(_buyer!=address(0),"swap is invalid");
        require(msg.sender==_buyer,"unauthorized");
        require(amount>0,"amount is zero");
        require(TradeExisting[_parentID],"Trade has ended or does not exist");
        TradeDetails memory ParentDetails = TradeTrack[_parentID];
        require(block.timestamp<ParentDetails.endtime,"time has exceeded trade no longer exists");
        require(data.WithdrawAmount<=ParentDetails.AvailableValue,"amount exceeds trade amount please recheck");
        ParentDetails.AvailableValue-=data.WithdrawAmount;
        data.WithdrawAmount=0;
        data.CompletionStatus=true;
        TradeTrack[_parentID]=ParentDetails;
        SwapTrack[_id]=data;
        uint8 _tokenIndex=ParentDetails.SellerGiveTokenIndex;
        feeCollected[_tokenIndex]+=data.feeAmount;
        TradeUpdating[_parentID]=false;
        IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).safeTransfer(_buyer, amount);
        emit SwapComplete(_id,_parentID,msg.sender);
    }



    // function withDrawSeller(uint256 _id) public whenNotPaused{
    //     require(!TradeCloneUpdating[_id],"Please send transaction in some time");
    //     TradeCloneUpdating[_id]=true;
    //     require(TradeExisting[_id],"trade Does not exist");
    //     TradeClone memory data = TradeCloneTrack[_id];
    //     uint256 _amount=data.currentBalance-data.feeAmount;
    //     data.feeAmount=0;
    //     require(_amount>0,"y'all need to chill");
    //     require(msg.sender==data.seller,"unauthorized");
    //     data.currentBalance-=(_amount+data.feeAmount);
    //     data.MaxBalance-=_amount;
    //     TradeCloneTrack[_id]=data;
    //     uint8 _tokenIndex=data.SellerGetTokenIndex;
    //     if(block.timestamp> data.endtime)
    //     {
    //         TradeExisting[_id]=false;
    //     }
    //     TradeCloneUpdating[_id]=false;
    //     IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).transfer(data.seller, _amount);
    //     emit Sellerwithdraw(_id,msg.sender,_amount);
    // }


    function refundSeller(uint256 _id) public whenNotPaused {
         require(!TradeUpdating[_id],"Please send transaction in some time");
        TradeUpdating[_id]=true;
        TradeDetails memory data = TradeTrack[_id];
        require(msg.sender==data.seller,"unauthorized");
        require(TradeExisting[_id],"stop get some help");
        require(data.AvailableValue>0,"there are no funds available for refund");
        require(block.timestamp>data.endtime,"the trade is ongoing");
        TradeExisting[_id]=false;
        uint256 _amount=data.AvailableValue;
        data.AvailableValue-=_amount;
        TradeTrack[_id]=data;
       uint8 _tokenIndex=data.SellerGiveTokenIndex;
       TradeUpdating[_id]=false;
         IERC20Upgradeable(Whitelistedtokens[_tokenIndex]).safeTransfer(data.seller, _amount);
         emit refunded(_id,msg.sender,_amount);
    }
    //  function viewTrades(uint256 id)
    //     public
    //     view
    //     onlyOwner
    //     returns (TradeDetails memory)
    // {
    //     require(TradeExisting[id],"Trade does not exist");
    //     return TradeTrack[id];
    // }

    //  function viewTradeClones(uint256 id)
    //     public
    //     view
    //     onlyOwner
    //     returns (TradeClone memory)
    // {
    //     require(TradeExisting[id],"Trade does not exist");
    //     return TradeCloneTrack[id];
    // }
    // function viewSwaps(uint256 id)
    //     public
    //     view
    //     onlyOwner
    //     returns (SwapDetails memory)
    // {
    //     return SwapTrack[id];
    // }

function withdrawFee(uint8 _index) public onlyOwner whenNotPaused
{
    require(feeCollected[_index]>0,"no fees available");
    uint256 _amount=feeCollected[_index];
    feeCollected[_index]=0;
    IERC20Upgradeable(Whitelistedtokens[_index]).safeTransfer(msg.sender,_amount);

}

}
