# Contracts and their intended functionalities 
## Liquidity pool
1. setUSDAddress --onlyOwner -- params(index,Name,token contract address) -- This function is used to update or set the tokens that can be accepted to the pool for stakes(to avoid fake tokens) <br />
2.stake --params(index,amount)-- index points to which token is being staked and amount. <br />
3.unstake --params(index,amount)-- index points to which token is being unstaked and amount is always lesser than 80% of staked tokens <br />
4.unstakeAll --params(index) -- index points to which token is being unstaked completely--Only possible when epoch is over and 80% is withdrawn beforehand <br />
5.setEpoch --onlyOwner -- params(bool over) -- this is set to true and only then the staker can unstake remaining tokens <br />

event Stake(string USD, address liquidityProvider, uint256 amount,uint256 USDtotal, uint256 TotalStake);

    event Unstake(
        string USD,
        address liquidityProvider,
        uint256 amount,
        uint256 USDtotal,
        uint256 TotalStake
    );
    
    
contract should revert-- <br />

unstakeall when epoch is false<br />
Everything when paused is true <br />
unstakeAll when 80% not yet unstaked <br />
stake when amount is zero<br />
stake when index does not exist<br />

## Treasurypool 
1. setUSDAddress --onlyOwner -- params(index,Name,token contract address) -- This function is used to update or set the tokens that can be accepted to the pool for stakes(to avoid fake tokens)<br />
2.Buy --params(index,amount)-- index points to which token is being used to buy and amount.<br />
3.Redeem --onlyOwner -- params(redeemerAddress,index,amount) -- The owner can send USD stable tokens to redeemer upon confirmation of token burn.<br />

contract should revert-- <br />
Everything when paused is true<br />
Buy when amount is zero<br />
Buy when index does not exist<br />

event Recieved(string USD,uint256 ID, address buyer, uint256 amount,uint256 balanceNew,uint256 UsdBalance); // upon recieve there should be a mint

event Redeemed(string USD, address redeemer, uint256 amount,uint256 balanceNew,uint256 USDbalance); // upon redeem there should be equal burn


## APY contract
It accepts the Chaidex governance/fee token from users who use the DEX and seperates them to wallets for maintenance and APY to stakers are provided in USD equivalent of current ChaiT price Or in CHaiT.<br />

1.fees--params(amount)-- amount of chait Paid as fee is distributed to 2 wallets.<br />

## INRC and ChaiT contracts
These are default ERC20 contracts and follow all rules set by the standard<br />
The INRC contract has an event emitter whenever redeem is called which will trigger the redeem function in the treasury pool<br />

The ChaiT contract is  default  erc20 contract.<br />




## DEX Logic / HTLC

### The Working and Flow 
A seller deposits a sum of tokenX in chainX in the ERC20 contract.
He quotes an equivalent INRC he expects to receive per token.
These details of the maximum INRC a buyer can deposit and the is cloned onto the INRC chain where buyers can deposit.
The INRC deposited is directly sent to the seller after deducting the Info update charges in crosschain.

Now once a buyer deposits to the INRC contract with the tradeID the amount of tokenX he should recieve is updated on ChainX. 
The trade is time limited and hence the buyer should go to chainX and withdraw his amount before the trade is over(upon which tokenX gets refunded regardless of the success of buyer swap).

Same goes for the other way round 
The seller deposits INRC ine exchange for TokenX in chainX which is updated in ChainX where the buyers deposit TokenX for a swap and withdraws equivalent INRC

This involves the requirement of payment of platform fee in terms of Chai Tokens in violation of which the trade will not exist.


### Functions and parameters (for ERC)
1.depositSeller 

              --address _seller, --seller address     --In ERC contract /ChainX

                  uint256 _id, -- unique TradeID which is orgin in the current chain

                 uint256 _amount, -- TradeDeposit Amount

                 uint8 _tokenIndex, -- Tokens are mapped to their addresses so the right token for deposit is chosen

                 uint256 _endtime -- It is the duration for which the Trade should exist starting from then


2.setTradeCloneID(OnlyOwner) 
                       
                       uint256 _id, 

                       address _seller ,

                       uint256 _endtime,

                      uint256 _maxAmount,

                      uint8 _sellerTokenIndex,

                      uint256 _feetoBepaid

3.depositBuyer --
                 
                 uint256 _id, // This is the ID of a TradeClone for a trade existing on oposite chain

                 uint256 _amount // the amount to be deposited 

4. setSwapID

                (uint256  _id,
                uint256 _parentID,
                address _buyer,
                uint256 _withdrawamount,
                uint256 _feeAmount) --OnlyOwner

here _id is the SwapID that we generate for the deposit in other chain

parentID is the TradeID from which the buyer will withdraw 

feeAmount is the fee that will be deducted from withdraw amount before sending it to him.

5.withDrawBuyer

              (uint256 _id)

Here The ID is swapID that was updated earlier 

6. refundSeller

              (uint256 _id)

Here ID is the trade ID so that after time is over the seller can take back any remaining funds.

7. Only in INRC -- PayFeeCHT

              (uint256 _trade    
              uint256 _amount)

The buyer or seller will have to pay fee before initiating the deposit overriding which will lose their deposit amount.

8.setUSDAddress --onlyOwner -- params(index,Name,token contract address) 

9.withdrawFee
             
             (uint8 _index) --only owner --transfers all fee collected all fee collected

### Functions and parameters (for INRC and Native)

#### For INRC approval of INRC is needed before calling deposit functions 

#### For Natives an attached deposit of equivalent amount must be sent i.e _amount==msg.value
1.depositSeller 

              --address _seller, --seller address     --In ERC contract /ChainX

                  uint256 _id, -- unique TradeID which is orgin in the current chain

                 uint256 _amount, -- TradeDeposit Amount

                 uint256 _endtime -- It is the duration for which the Trade should exist starting from then


2.setTradeCloneID(OnlyOwner) 

                       uint256 _id, 
                       address _seller ,
                       uint256 _endtime,
                      uint256 _maxAmount,
                      uint256 _feetoBepaid

3.depositBuyer --
                   
                 uint256 _id, // This is the ID of a TradeClone for a trade existing on oposite chain

                 uint256 _amount // the amount to be deposited 

4. setSwapID

               (uint256  _id,
               uint256 _parentID,
               address _buyer,
               uint256 _withdrawamount,
               uint256 _feeAmount) --OnlyOwner

here _id is the SwapID that we generate for the deposit in other chain

parentID is the TradeID from which the buyer will withdraw 

feeAmount is the fee that will be deducted from withdraw amount before sending it to him.

5.withDrawBuyer
                 
                 (uint256 _id)

Here The ID is swapID that was updated earlier 

6. refundSeller  
                                        
               (uint256 _id)

Here ID is the trade ID so that after time is over the seller can take back any remaining funds.

7. Only in INRC -- PayFeeCHT
                
                (uint256 _tradeid, // this can be swapID or tradeID or tradeCloneID 
                                  // No conflicts will be there as each are unique and the only thng this does is set feepaid to true onchain
               uint256 _amount)  //without which trades or swaps wont happen
                  

The buyer or seller will have to pay fee before initiating the deposit overriding which will lose their deposit amount.


#### Events Emitted 
event tradeCreated (uint256 _Tradeid,address Seller,uint256 _amount);

event tradeCloneCreated (uint256 _TradeCloneid,address Seller);

event BuyerDeposit(uint256 _TradeCloneID,address Buyer,uint256 _amount);

event SwapComplete(uint256 _swapID,uint256 Parent,address Buyer);

event swapCreated(uint256 _SwapID,address Buyer);

event Sellerwithdraw(uint256 _TradeCloneid,address Seller,uint256 _amount);

event refunded(uint256 _Tradeid,address Seller,uint256 _amount);

## Test USD token(only for testing)

Standard token to test on testnet
