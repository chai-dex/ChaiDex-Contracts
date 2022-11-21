# Contracts and their intended functionalities 
## Liquidity pool
1. setUSDAddress --onlyOwner -- params(index,Name,token contract address) -- This function is used to update or set the tokens that can be accepted to the pool for stakes(to avoid fake tokens) <br />
2.stake --params(index,amount)-- index points to which token is being staked and amount. <br />
3.unstake --params(index,amount)-- index points to which token is being unstaked and amount is always lesser than 80% of staked tokens <br />
4.unstakeAll --params(index) -- index points to which token is being unstaked completely--Only possible when epoch is over and 80% is withdrawn beforehand <br />
5.setEpoch --onlyOwner -- params(bool over) -- this is set to true and only then the staker can unstake remaining tokens <br />

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

## APY contract
It accepts the Chaidex governance/fee token from users who use the DEX and seperates them to wallets for maintenance and APY to stakers are provided in USD equivalent of current ChaiT price Or in CHaiT.<br />

1.fees--params(amount)-- amount of chait Paid as fee is distributed to 2 wallets.<br />

## INRC and ChaiT contracts
These are default ERC20 contracts and follow all rules set by the standard<br />
The INRC contract has an event emitter whenever redeem is called which will trigger the redeem function in the treasury pool<br />

The ChaiT contract is  default  erc20 contract.<br />




## DEX Logic / HTLC
This contract is used to store the dex exchange currencies until a trade is either completed with the successful exchange or a refund after 24 hours. It involves swap between native and INRC tokens only . It takes passphrase of both users and compares and only the unlocks required funds for unlock

1.deposit -- payable-- params( 
        address seller,
        uint256 amount,
        uint256 id,
        string calldata passphrase,
        address buyer,
        uint256 chainIDBuyer,
        uint256 amount2) -- native tokens<br />

2.depositINRC -- params( address seller,
        uint256 amount,
        uint256 id,
        string calldata passphrase,
        address buyer,
        uint256 chainIDBuyer,
        uint256 amount2) -- to deposit INRC tokens for trade -- <br />

3.withDraw --payable --params(uint256 id, string calldata password) -- requires password and directly sends funds to buyer address only <br />
4.withDrawINRC --params(uint256 id, string calldata password)--requires password and directly sends funds to buyer address only <br />
5.reFund --payable--params(uint256 id) -- refunds if nobody withdraws after 24 hrs to the seller only<br />
6.refFundINRC --params(uint256 id) -- refunds if nobody withdraws after 24 hrs to the seller only<br />
7.compareDigest --internal --params( string memory digest, string memory secret) -- to check password befor withdraw<br />


## Test USD token(only for testing)

Standard token to test on testnet