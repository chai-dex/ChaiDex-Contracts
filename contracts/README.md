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
## Escrow ERC contract

## EscrowERC Contract

### initialize()

**Description:**
Initializes the EscrowERC contract.

### setERCAddress(uint8 _index, string memory _name, address _token)

**Parameters:**
- `_index`: Index of the ERC20 token.
- `_name`: Name of the ERC20 token.
- `_token`: Address of the ERC20 token.

**Description:**
Sets the address and name of an ERC20 token.

**Reverts:**
- If called by a non-owner address. (`Ownable: caller is not the owner`)

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

### depositSeller(address _seller, uint256 _id, uint256 _amount, uint8 _tokenIndex, uint256 _endtime)

**Parameters:**
- `_seller`: Address of the seller.
- `_id`: Unique identifier for the trade.
- `_amount`: Amount of tokens to deposit.
- `_tokenIndex`: Index of the token used.
- `_endtime`: End time for the trade.

**Description:**
Allows the seller to deposit tokens for a trade.

**Reverts:**
- If not called by the seller. (`unauthorized`)
- If the trade already exists. (`trade already exists`)
- If the amount is zero. (`amount cannot be zero`)
- If the end time is not greater than zero. (`Endtime must be greater`)

### depositBuyer(uint256 _id, uint256 _amount, uint8 _tokenIndex)

**Parameters:**
- `_id`: Unique identifier for the trade.
- `_amount`: Amount of tokens to deposit.
- `_tokenIndex`: Index of the token used.

**Description:**
Allows the buyer to deposit tokens for a trade.

**Reverts:**
- If the amount is zero. (`amount cannot be zero`)
- If the trade does not exist. (`trade Does not exist`)
- If the trade clone is updating. (`Please send transaction in some time`)
- If the buyer has already opted for the trade. (`you can only opt for a trade once`)
- If the seller is the same as the buyer. (`seller cant buy`)
- If the trade no longer has funds. (`The trade no longer has funds`)
- If the trade has ended. (`This trade has ended`)
- If the token is not accepted. (`token not accepted`)
- If the amount is too low. (`amount too low`)

### withDrawBuyer(uint256 _id)

**Parameters:**
- `_id`: Unique identifier for the swap.

**Description:**
Allows the buyer to withdraw their funds from a swap.

**Reverts:**
- If the swap does not exist. (`swap does not exist`)
- If the withdrawal is already completed. (`withdraw completed`)
- If the parent trade is updating. (`Please send transaction in some time`)
- If the trade has ended or does not exist. (`Trade has ended or does not exist`)
- If the time has exceeded and the trade no longer exists. (`time has exceeded trade no longer exists`)
- If the amount exceeds the trade amount. (`amount exceeds trade amount please recheck`)

### refundSeller(uint256 _id)

**Parameters:**
- `_id`: Unique identifier for the trade.

**Description:**
Allows the seller to refund the buyer.

**Reverts:**
- If the trade is updating. (`Please send transaction in some time`)
- If not called by the seller. (`unauthorized`)
- If the trade does not exist. (`stop get some help`)
- If there are no funds available for refund. (`there are no funds available for refund`)
- If the trade is still ongoing. (`the trade is ongoing`)

### setSwapID(uint256 _id, uint256 _parentID, address _buyer, uint256 _withdrawamount, uint256 _feeAmount)

**Parameters:**
- `_id`: Unique identifier for the swap.
- `_parentID`: Unique identifier for the parent trade.
- `_buyer`: Address of the buyer.
- `_withdrawamount`: Amount to withdraw in the swap.
- `_feeAmount`: Fee amount for the swap.

**Description:**
Sets the details for a swap.

**Reverts:**
- If the swap ID already exists. (`swap still in progress`)
- If the parent trade does not exist. (`Trade has ended or does not exist`)
- If the amount is zero. (`non zero values only`)
- If the amount should be greater than the fee. (`amount should be greater than fee`)
- If the address is invalid. (`invalid address`)
### setTradeCloneID(bytes32 _id, address _seller ,uint256 _endtime,uint256 _maxAmount,uint8[3] memory _sellerTokenIndex ,uint256[3] memory _convertionFactors ,uint256 _feetoBepaid)

**Parameters:**
- `_id` : New tradeclone ID
- `_convertionFactor` : the factor of convertion between selected token and the seller token
eg: if 1 eth listed @ 100 USDC as first token and 200 Matic as 2nd token
convertion factor for first one is 0.001*10**18 and for matic is 0.002*10**18
### withdrawFee(uint8 _index)

**Parameters:**
- `_index`: Index of the token.

**Description:**
Allows the owner to withdraw the collected fee for a specific token.

**Reverts:**
- If there are no fees available. (`no fees available`)
- If called by a non-owner address. (`Ownable: caller is not the owner`)
## Events
### tradeCreated

Parameters:

- `_Tradeid`: Unique identifier for the trade.
- `Seller`: Address of the seller.
- `_amount`: Amount of tokens involved in the trade.

Description:

Emitted when a trade is created.

### tradeCloneCreated

Parameters:

- `_TradeCloneid`: Unique identifier for the cloned trade.
- `Seller`: Address of the seller.

Description:

Emitted when a cloned trade is created.

### BuyerDeposit

Parameters:

- `_TradeCloneID`: Unique identifier for the cloned trade.
- `Buyer`: Address of the buyer.
- `_amount`: Amount of tokens deposited by the buyer.

Description:

Emitted when a buyer deposits tokens for a trade.

### SwapComplete

Parameters:

- `_swapID`: Unique identifier for the swap.
- `Parent`: Parent trade ID.
- `Buyer`: Address of the buyer.

Description:

Emitted when a swap is completed.

### swapCreated

Parameters:

- `_SwapID`: Unique identifier for the swap.
- `Buyer`: Address of the buyer.

Description:

Emitted when a swap is created.

### Sellerwithdraw

Parameters:

- `_TradeCloneid`: Unique identifier for the cloned trade.
- `Seller`: Address of the seller.
- `_amount`: Amount of tokens withdrawn by the seller.

Description:

Emitted when a seller withdraws tokens from a cloned trade.

### refunded

Parameters:

- `_Tradeid`: Unique identifier for the trade.
- `Seller`: Address of the seller.
- `_amount`: Amount of tokens refunded to the seller.

Description:

Emitted when a refund is initiated.

## EscrowNative
### Functions

#### `initialize`

Parameters: None

Description:

Initializes the contract. It sets up the contract state and should be called only once during deployment.

#### `tradeCreated`

Parameters:

- `_Tradeid`: uint256 - Unique identifier for the trade.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount involved in the trade.

Description:

Emitted when a trade is created.

#### `tradeCloneCreated`

Parameters:

- `_TradeCloneid`: uint256 - Unique identifier for the trade clone.
- `Seller`: address - Address of the seller.

Description:

Emitted when a trade clone is created.

#### `BuyerDeposit`

Parameters:

- `_TradeCloneID`: uint256 - Unique identifier for the trade clone.
- `Buyer`: address - Address of the buyer.
- `_amount`: uint256 - Amount deposited by the buyer.

Description:

Emitted when the buyer makes a deposit.

#### `SwapComplete`

Parameters:

- `_swapID`: uint256 - Unique identifier for the swap.
- `Parent`: uint256 - Parent trade ID.
- `Buyer`: address - Address of the buyer.

Description:

Emitted when a swap is completed.

#### `swapCreated`

Parameters:

- `_SwapID`: uint256 - Unique identifier for the swap.
- `Buyer`: address - Address of the buyer.

Description:

Emitted when a swap is created.

#### `Sellerwithdraw`

Parameters:

- `_TradeCloneid`: uint256 - Unique identifier for the trade clone.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount withdrawn by the seller.

Description:

Emitted when the seller initiates a withdrawal.

#### `refunded`

Parameters:

- `_Tradeid`: uint256 - Unique identifier for the trade.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount refunded.

Description:

Emitted when a refund is initiated.

#### `setSwapID`

Parameters:

- `_id`: uint256 - Unique identifier for the swap.
- `_parentID`: uint256 - Identifier of the parent trade.
- `_buyer`: address - Address of the buyer.
- `_withdrawamount`: uint256 - Amount to be withdrawn by the buyer.
- `_feeAmount`: uint256 - Fee amount associated with the swap.

Description:

Sets up a swap.

#### `setTradeCloneID`

Parameters:

- `_id`: uint256 - Unique identifier for the trade clone.
- `_seller`: address - Address of the seller.
- `_endtime`: uint256 - End time for the trade.
- `_maxAmount`: uint256 - Maximum balance allowed for the trade.
- `_feetoBepaid`: uint256 - Fee amount to be paid by the seller.

Description:

Sets up a trade clone.

#### `depositSeller`

Parameters:

- `_seller`: address - Address of the seller.
- `_id`: uint256 - Unique identifier for the trade.
- `_amount`: uint256 - Amount to be deposited.
- `_endtime`: uint256 - End time for the trade.

Description:

Allows the seller to deposit funds for a trade.

#### `depositBuyer`

Parameters:

- `_id`: uint256 - Unique identifier for the trade clone.
- `_amount`: uint256 - Amount to be deposited.

Description:

Allows the buyer to deposit funds for a trade clone.

#### `withDrawBuyer`

Parameters:

- `_id`: uint256 - Unique identifier for the swap.

Description:

Allows the buyer to initiate a withdrawal.

#### `refundSeller`

Parameters:

- `_id`: uint256 - Unique identifier for the trade.

Description:

Allows the seller to initiate a refund.

#### `withdrawFee`

Parameters: None

Description:

Allows the owner to withdraw collected fees.

#### `pause`

Parameters: None

Description:

Pauses the contract, preventing most functions from being called.

#### `unpause`

Parameters: None

Description:

Unpauses the contract, allowing functions to be called again.

### Reverts

#### `onlyOwner`

Description:

Reverts if the caller is not the owner of the contract.

#### `whenNotPaused`

Description:

Reverts if the contract is paused.

### Events

#### `tradeCreated`

Parameters:

- `_Tradeid`: uint256 - Unique identifier for the trade.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount involved in the trade.

Description:

Emitted when a trade is created.

#### `tradeCloneCreated`

Parameters:

- `_TradeCloneid`: uint256 - Unique identifier for the trade clone.
- `Seller`: address - Address of the seller.

Description:

Emitted when a trade clone is created.

#### `BuyerDeposit`

Parameters:

- `_TradeCloneID`: uint256 - Unique identifier for the trade clone.
- `Buyer`: address - Address of the buyer.
- `_amount`: uint256 - Amount deposited by the buyer.

Description:

Emitted when the buyer makes a deposit.

#### `SwapComplete`

Parameters:

- `_swapID`: uint256 - Unique identifier for the swap.
- `Parent`: uint256 - Parent trade ID.
- `Buyer`: address - Address of the buyer.

Description:

Emitted when a swap is completed.

#### `swapCreated`

Parameters:

- `_SwapID`: uint256 - Unique identifier for the swap.
- `Buyer`: address - Address of the buyer.

Description:

Emitted when a swap is created.

#### `Sellerwithdraw`

Parameters:

- `_TradeCloneid`: uint256 - Unique identifier for the trade clone.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount withdrawn by the seller.

Description:

Emitted when the seller initiates a withdrawal.

#### `refunded`

Parameters:

- `_Tradeid`: uint256 - Unique identifier for the trade.
- `Seller`: address - Address of the seller.
- `_amount`: uint256 - Amount refunded.

Description:

Emitted when a refund is initiated.

# P2pIntrachain 

## Functions

### `initialize()`

Initializes the contract.

#### Parameters

None

#### Revert Conditions

None

#### Events Emitted

None

### `pause()`

Pauses the contract. Only callable by the owner.

#### Parameters

None

#### Revert Conditions

- Must be called by the owner.

#### Events Emitted

None

### `unpause()`

Unpauses the contract. Only callable by the owner.

#### Parameters

None

#### Revert Conditions

- Must be called by the owner.

#### Events Emitted

None

### `setERCAddress(uint8 _index, string memory _name, address _token)`

Sets the address for a specific ERC20 token.

#### Parameters

- `_index` (uint8): Index of the token.
- `_name` (string): Name of the token.
- `_token` (address): Address of the token.

#### Revert Conditions

- Must not be paused.
- Must be called by the owner.

#### Events Emitted

None

### `setConstantFee(uint256 _percentage)`

Sets the constant fee percentage.

#### Parameters

- `_percentage` (uint256): The fee percentage.

#### Revert Conditions

- Must not be paused.
- Must be called by the owner.

#### Events Emitted

None

### `depositSeller(address _seller, bytes32 _id, uint256 _amount, uint8 _tokenIndex, uint256 _endtime, uint8[3] memory _sellerTokenIndex, uint256[3] memory _convertionFactors)`

Deposits funds from the seller for a trade.

#### Parameters

- `_seller` (address): Address of the seller.
- `_id` (bytes32): ID of the trade.
- `_amount` (uint256): Amount to deposit.
- `_tokenIndex` (uint8): Index of the token.
- `_endtime` (uint256): Endtime of the trade.
- `_sellerTokenIndex` (uint8[3] memory): Array of seller token indices.
- `_convertionFactors` (uint256[3] memory): Array of conversion factors.

#### Revert Conditions

- Must not be paused.
- Sender must be the seller.
- Trade must not already exist.
- Amount must be greater than 0.
- Endtime must be greater than 0.

#### Events Emitted

- `tradeCreated(bytes32 _Tradeid, address Seller, uint256 _amount)`

### `depositSeller(address _seller, bytes32 _id, uint256 _amount, uint256 _endtime, uint8[3] memory _sellerTokenIndex, uint256[3] memory _convertionFactors)`

Deposits funds from the seller for a trade with ETH.

#### Parameters

- `_seller` (address): Address of the seller.
- `_id` (bytes32): ID of the trade.
- `_amount` (uint256): Amount to deposit.
- `_endtime` (uint256): Endtime of the trade.
- `_sellerTokenIndex` (uint8[3] memory): Array of seller token indices.
- `_convertionFactors` (uint256[3] memory): Array of conversion factors.

#### Revert Conditions

- Must not be paused.
- Sender must be the seller.
- Trade must not already exist.
- Amount must be greater than 0.
- Value must be greater than 0.
- Endtime must be greater than 0.

#### Events Emitted

- `tradeCreated(bytes32 _Tradeid, address Seller, uint256 _amount)`

### `depositBuyer(bytes32 _id, uint256 _amount, uint8 _tokenIndex)`

Deposits funds from the buyer for a trade.

#### Parameters

- `_id` (bytes32): ID of the trade.
- `_amount` (uint256): Amount to deposit.
- `_tokenIndex` (uint8): Index of the token.

#### Revert Conditions

- Must not be paused.
- Amount must be greater than 0.
- Trade must exist.
- Token must be accepted for the trade.
- Funds must be available for the trade.
- Trade must not have ended.
- Seller address must be valid.
- Buyer cannot be the seller.

#### Events Emitted

- `BuyerDeposit(bytes32 _TradeCloneID, address Buyer, uint256 _amount, uint256 recievedAmount)`

### `depositBuyer(bytes32 _id, uint256 _amount)`

Deposits funds from the buyer for a trade with ETH.

#### Parameters

- `_id` (bytes32): ID of the trade.
- `_amount` (uint256): Amount to deposit.

#### Revert Conditions

- Must not be paused.
- Amount must be greater than 0.
- Trade must exist.
- Token must be accepted for the trade.
- Funds must be available for the trade.
- Trade must not have ended.
- Seller address must be valid.
- Buyer cannot be the seller.

#### Events Emitted

- `BuyerDeposit(bytes32 _TradeCloneID, address Buyer, uint256 _amount, uint256 recievedAmount)`

### `refundSeller(bytes32 _id)`

Refunds the seller for a trade.

#### Parameters

- `_id` (bytes32): ID of the trade.

#### Revert Conditions

- Must not be paused.
- Trade update must not be in progress.
- Sender must be the seller.
- Trade must exist.
- Funds must be available for refund.
- Trade must have ended.

#### Events Emitted

- `refunded(bytes32 _Tradeid, address Seller, uint256 _amount)`

### `withdrawFee(uint8 _index)`

Withdraws collected fees.

#### Parameters

- `_index` (uint8): Index of the token.

#### Revert Conditions

- Must not be paused.
- Fee must be available for withdrawal.

#### Events Emitted

None



## Test USD token(only for testing)

Standard token to test on testnet
