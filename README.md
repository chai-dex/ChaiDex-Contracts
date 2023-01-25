# INRC mint and DEX logic 
To understand the contract functions individually please head over to [Contracts description](contracts/README.md)</br>
To know the Test setup and audit setup go to [test-setup](test/readME.md)

## INRC minting
INRC is a stablecoin which is pegged to usd stables and converted to INR and minted.
There are two pools where the USD stablecoins go into.
One is a Liquidity pool where the users stake their USD stablecoins whose volume defines the maximum amount of INRC can be minted. 

The other is the treasury pool where the users who buy INRC in exchange for stablecoins and can be burnt to redeem the stablecoin of their choice.

The treasury pool emits events whenever there is a buy which triggers the mint in the INRC contract. And redeem/burn of inrc triggers the usd stables transfer from Treasurypool.

Stakers can withdraw 80% of their stakes at anytime and remaining after an epoch is over. 
The current trusted stablecoins are USDC USDT and BUSD.

INRC will be on the bitgert chain and the treasury pool , liquidty pool are multichain on EVM.
![WhatsApp Image 2022-12-21 at 6 04 13 PM](https://user-images.githubusercontent.com/81789395/208907078-1a14ec8a-202f-4a7a-a1e1-e0008366a934.jpeg)

## DEX Logic


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

