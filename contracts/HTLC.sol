// SPDX-License-Identifier: MIT
// CHAIDEX Version 1
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract htlc is  Initializable,PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {


  function initialize() public initializer {
       __UUPSUpgradeable_init();
       __Ownable_init();
       __Pausable_init();

   }

   function _authorizeUpgrade(address newContract) internal override onlyOwner {}
 function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }



    uint256 public constant MAX_DELAY = 86400; 

     struct  Track  {
        uint256 id;
        address seller;
        uint256 blocktStamp;
        uint256 value;
        string passphrase;
        address buyer;
        uint256 BuyerChainId;
    }
    mapping(address => uint256) private Trades;
    mapping(uint256 => Track) private TradeTrack;
    mapping(uint256 => bool) private TradeQueued;
    mapping(uint256 => Track) private TradeTrackINRC;
    mapping(uint256 => bool) private TradeInprogress;
    event Deposit(
        uint256 TradeID,
        address seller,
        address buyer,
        uint256 amountNat,
        uint256 amountINRC,
        uint256 timestamp,
        uint256 chainIDSeller,
        uint256 chainIDBuyer
    );
    error AlreadyExisting(uint256 id);
    error TradeDoesntExist(uint256 id);
    address public INRC;


   

    function setAddress(address _INRC) public onlyOwner {
        INRC = _INRC;
    }

   
    function deposit(
        address seller,
        uint256 amount,
        uint256 id,
        string calldata passphrase,
        address buyer,
        uint256 chainIDBuyer,
        uint256 amount2
    ) public payable whenNotPaused {
        uint256 value = msg.value;
        require(value == amount, "Improper");
        require(msg.sender == seller, "Personal only");
        if (TradeQueued[id]) {
            revert AlreadyExisting(id);
        }
        Trades[seller] = amount;
        uint256 blockTimeStamp = block.timestamp;
        Track memory data = Track(
            id,
            seller,
            blockTimeStamp,
            value,
            passphrase,
            buyer,
            chainIDBuyer
        );
        TradeTrack[id] = data;
        TradeQueued[id] = true;
        TradeInprogress[id] = true;
        emit Deposit(
            id,
            seller,
            buyer,
            amount,
            amount2,
            blockTimeStamp,
            80001,
            chainIDBuyer
        );
    }

    function tradesData(address seller) internal view returns (uint256) {
        uint256 amount = Trades[seller];
        return amount;
    }

    function depositINRC(
        address seller,
        uint256 _amount,
        uint256 id,
        string calldata passphrase,
        address buyer,
        uint256 chainIDBuyer,
        uint256 amount2
    ) public whenNotPaused {
        require(msg.sender == seller, "Personal only");
        if (TradeQueued[id]) {
            revert AlreadyExisting(id);
        }
        Trades[seller] = _amount;
        uint256 blockTimeStamp = block.timestamp;
        Track memory data = Track(
            id,
            seller,
            blockTimeStamp,
            _amount,
            passphrase,
            buyer,
            chainIDBuyer
        );
        TradeTrackINRC[id] = data;
        TradeQueued[id] = true;
        TradeInprogress[id] = true;
        IERC20(INRC).transferFrom(msg.sender, address(this), _amount);

        emit Deposit(
            id,
            seller,
            buyer,
            _amount,
            amount2,
            blockTimeStamp,
            80001,
            chainIDBuyer
        );
    }

    function reFund(uint256 id) public payable whenNotPaused {
        Track memory refundedTo = TradeTrack[id];
        if (!TradeQueued[id]) {
            revert TradeDoesntExist(id);
        }
        require(TradeInprogress[id], "Trade doesnt exist or is Closed");
        require(refundedTo.seller == msg.sender, "Unauthorized");
        require(tradesData(refundedTo.seller) > 0, "No Amount");
        uint256 currentTimeStamp = refundedTo.blocktStamp + MAX_DELAY;
        require(block.timestamp > currentTimeStamp, "Cannot withdraw yet");
        TradeInprogress[id] = false;
        payable(refundedTo.seller).transfer(refundedTo.value);

     

    }

    function reFundINRC(uint256 id) public whenNotPaused {
        Track memory refundedTo = TradeTrackINRC[id];
        if (!TradeQueued[id]) {
            revert TradeDoesntExist(id);
        }
        require(TradeInprogress[id], "Trade doesnt exist or is Closed");
        require(refundedTo.seller == msg.sender, "Unauthorized");
        require(tradesData(refundedTo.seller) > 0, "No Amount");
        uint256 currentTimeStamp = refundedTo.blocktStamp + MAX_DELAY;
        require(block.timestamp > currentTimeStamp, "Cannot withdraw yet");
        TradeInprogress[id] = false;
        IERC20(INRC).transfer(refundedTo.seller, refundedTo.value);
    }

    function viewTrades(uint256 id)
        public
        view
        onlyOwner
        returns (Track memory)
    {
        return TradeTrack[id];
    }

    function compareDigest(string memory digest, string memory secret)
        internal
        pure
        returns (bool)
    {
        if (
            keccak256(abi.encodePacked(digest)) ==
            keccak256(abi.encodePacked(secret))
        ) return true;
        return false;
    }

    function withDraw(uint256 id, string calldata password) public payable whenNotPaused {
        //change token1 and token2 to enum
        Track memory data = TradeTrack[id];
        address to = data.buyer;
        require(TradeInprogress[id], "Trade is already closed or doesnt exist");
        require(to == data.buyer, "You can only use Refund");
        require(compareDigest(password, data.passphrase), "Incorrect password");
         TradeInprogress[id] = false;
        payable(to).transfer(data.value);
        // (bool sent, ) = to.call{value: data.value}(" SENT ");
        // require(sent, "Failed Transaction");

        data.value = 0;
    }

    function withDrawINRC(uint256 id, string calldata password) public whenNotPaused {
        //change token1 and token2 to enum

        Track memory data = TradeTrackINRC[id];
        require(TradeInprogress[id], "Trade is already closed");
        address to = data.buyer;
        require(to == data.buyer, "You can only use Refund");
        require(compareDigest(password, data.passphrase), "Incorrect password");
        TradeInprogress[id] = false;
        IERC20(INRC).transfer(data.buyer, data.value);
        // (bool sent, ) = to.call{value: data.value}(" SENT ");
        // require(sent, "Failed Transaction");
        data.value = 0;
    }
}

//10000000000000000000