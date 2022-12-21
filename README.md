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

The smart contract is an upgradeable logic contract that caters to the storing of funds through deposits, withdrawals, and refunds. With respect to the architecture, the contract is deployed on different chains and has a unique TradeID and a passphrase that has to be passed in to the functions while calling any of them for either refund, deposit or withdrawals.
Now for a trade that involves trade-off of a native token and INRC, as any trades that happen in DeX happen against INRC only, hence, when a trade is matched through the backend and you have to deposit the amount, the respective chain of the native token is called and parameters involving a passphrase and trade Id is called. Now when the other party deposits bitgert chain, INRC exists here, and is called with the same tradeID but with a different passphrase set by this party. Hence once both funds are locked, in order to withdraw the required token, the passphrase corresponding to that trade id on that respective chain needs to be sent as a parameter which ensures the safety of transfers without the need for bridges or wrapped tokens as the passphrase saves all the funds in the respective chains. If the other party doesn't put in the amount within 24 hours, you can withdraw the amount as the chain is updated with the owner of those tokens and hence can transfer your tokens back. 

Therefore, in order to access any funds out, only the required party will be able to do it as only the required party will get your passphrase. 

![WhatsApp Image 2022-12-21 at 6 04 13 PM (1)](https://user-images.githubusercontent.com/81789395/208906508-668febbc-be5c-4935-ac42-a20734d14e9f.jpeg)
