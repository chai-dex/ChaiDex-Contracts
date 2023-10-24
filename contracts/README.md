# Contracts and their intended functionalities 
## LiquidityPool Contract

### initialize()

**Description:**
Initializes the LiquidityPool contract.

### pause()

**Description:**
Pauses the contract, preventing further operations.

**Reverts:**
- If called by a non-owner address.

### unpause()

**Description:**
Unpauses the contract, allowing operations to resume.

**Reverts:**
- If called by a non-owner address.

### setEpoch(bool _over)

**Parameters:**
- `_over`: Boolean indicating if the epoch is over.

**Description:**
Sets the status of the current epoch.

**Reverts:**
- If called by a non-owner address.

### setUnstake(bool _over)

**Parameters:**
- `_over`: Boolean indicating if unstaking is allowed.

**Description:**
Sets whether unstaking is currently allowed or not.

**Reverts:**
- If called by a non-owner address.

### setUSDAddress(uint8 _index, string memory _name, address _USD)

**Parameters:**
- `_index`: Index of the stable coin.
- `_name`: Name of the stable coin.
- `_USD`: Address of the stable coin.

**Description:**
Sets the address and name of a stable coin.

**Reverts:**
- If called by a non-owner address.

### stake(bytes32 _id, uint8 _usd, uint256 _amount)

**Parameters:**
- `_id`: Unique identifier for the stake.
- `_usd`: Index of the USD Stable Coin.
- `_amount`: Amount of USD to Stake.

**Description:**
Stakes a specified amount of USD in the LiquidityPool.

**Reverts:**
- If `_amount` is zero.

### unstake(uint8 _usd, uint256 _amount)

**Parameters:**
- `_usd`: Index of the USD Stable Coin.
- `_amount`: Amount of USD to Unstake.

**Description:**
Unstakes a specified amount of USD from the LiquidityPool.

**Reverts:**
- If `_amount` is greater than or equal to 80% of the balance.

### unstakeAll(uint8 _usd)

**Parameters:**
- `_usd`: Index of the USD Stable Coin.

**Description:**
Unstakes all the available USD from the LiquidityPool for a specific stable coin.

**Reverts:**
- If epoch is not over.
- If unstake is not allowed.

### getLPbalance(uint8 _length )

**Parameters:**
- `_length`: Length of the array to be returned.

**Description:**
Returns the balance of the Liquidity Pool.

### GetStakers(uint64 _num1, uint64 _num2)

**Parameters:**
- `_num1`: Start index for fetching stakers.
- `_num2`: End index for fetching stakers.

**Description:**
Returns a list of stakers within a specified range.

---

### Events

#### Stake

**Parameters:**
- `USD`: The name of the USD Stable Coin.
- `stakeID`: Unique identifier for the stake.
- `liquidityProvider`: Address of the liquidity provider.
- `amount`: Amount of USD staked.
- `USDtotal`: Total USD staked by the provider.
- `TotalStake`: Total USD staked in the pool.

#### Unstake

**Parameters:**
- `USD`: The name of the USD Stable Coin.
- `liquidityProvider`: Address of the liquidity provider.
- `amount`: Amount of USD unstaked.
- `USDtotal`: Total USD staked by the provider after unstaking.
- `TotalStake`: Total USD staked in the pool after unstaking.


## TreasuryPool Contract

The TreasuryPool contract is responsible for managing a pool of stable coins and native coins.

## TreasuryPool Contract

### initialize()

**Description:**
Initializes the TreasuryPool contract.

### setMinter(bool _over)

**Parameters:**
- `_over`: Boolean indicating if the maximum minting is reached.

**Description:**
Sets the status of the maximum minting.

### setDisable(bool _disable)

**Parameters:**
- `_disable`: Boolean indicating if buying using native coins is disabled.

**Description:**
Sets whether buying using native coins is currently allowed or not.

### pause()

**Description:**
Pauses the contract, preventing further operations.

**Reverts:**
- If called by a non-owner address. (`Ownable: caller is not the owner`)

### unpause()

**Description:**
Unpauses the contract, allowing operations to resume.

**Reverts:**
- If called by a non-owner address. (`Ownable: caller is not the owner`)

### setUSDAddress(uint8 _index, string memory _name, address _USD)

**Parameters:**
- `_index`: Index of the stable coin.
- `_name`: Name of the stable coin.
- `_USD`: Address of the stable coin.

**Description:**
Sets the address and name of a stable coin.

**Reverts:**
- If called by a non-owner address. (`Ownable: caller is not the owner`)

### Buy(uint8 _usd, bytes32 MintID, uint256 _amount)

**Parameters:**
- `_usd`: Index of the USD Stable Coin.
- `MintID`: Unique identifier for the mint.
- `_amount`: Amount of USD to buy.

**Description:**
Adds funds to the Treasury Pool and emits a `Recieved` event.

**Reverts:**
- If `_amount` is zero. (`amount cannot be 0`)
- If maximum minting is reached. (`Maximum minting reached`)

### BuyNat(bytes32 MintID)

**Parameters:**
- `MintID`: Unique identifier for the mint.

**Description:**
Allows buying using native coins and emits a `Recieved` event.

**Reverts:**
- If the amount sent is zero. (`amount cannot be 0`)
- If maximum minting is reached. (`Maximum minting reached`)
- If buying using native coins is disabled. (`Cannot buy using native coins anymore`)

### Redeem(address redeemer, uint8 _usd, uint256 _amount)

**Parameters:**
- `redeemer`: Address of the redeemer.
- `_usd`: Index of the USD Stable Coin.
- `_amount`: Amount of USD to redeem.

**Description:**
Authorizes the user's redeem request, sends them the funds, and deducts equivalent inrc.

**Reverts:**
- If `_amount` is zero. (`amount cannot be 0`)
- If the balance is insufficient for redemption. (`Not enough balance`)

### RedeemNat(address redeemer, uint256 _amount)

**Parameters:**
- `redeemer`: Address of the redeemer.
- `_amount`: Amount of native coins to redeem.

**Description:**
Authorizes the user's native coin redeem request, sends them the funds, and deducts equivalent inrc.

**Reverts:**
- If `_amount` is zero. (`amount cannot be 0`)
- If maximum minting is reached. (`Maximum minting reached`)
- If buying using native coins is disabled. (`Cannot buy using native coins anymore`)

### getTPbalance(uint8 _length )

**Parameters:**
- `_length`: Length of the array to be returned.

**Description:**
Returns the balance of the Treasury Pool.


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
