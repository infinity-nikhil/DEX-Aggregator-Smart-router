Yo chat ...how's every one doing it's me the OG POPCORN!! 
And this time we are trying to create a DEX Aggregator / smart router
Those who don't know what this is just research on the internet dwag.... 
We will try to cover both the frontend and backend so each one detail will be in there respective readme.md 

## So starting with the contract first (Aggregator.sol):
### Major function
->transferOwnership
->acceptOwnership 
-> setFee
-> _split
-> _skim
-> setv4PoolAllowed
-> _checkLegs

tbh i also don't know the major function we vibe coded it and hence will learn it but the code works 
So lets begin with transferOwner ship 
In crux: It is simply used to transfer the ownership of the contract (see in the code)
I have explained both transferOwnership and accpetOwnership in code 
Also the var "owner" address only holds power cause in contract there are check of require of onwer. THAT IS IT!! 

Now let's talk about the setFee and split functions 
setFee() → Only the owner can change the protocol fee. It ensures the fee doesn't exceed HARD_CAP (100 bps = 1%).
_split() → Takes an amount of USDG and splits it into:
fee = percentage taken as the fee
rest = remaining amount after the fee

Example: if usdgLeg = 1000 and feeBps = 50 → 5 USDG fee + 995 USDG remaining.

Now on to the _skim function 
If fee > 0 → transfer that amount of USDG to feeWallet.
If fee == 0 → do nothing.
safeTransfer() safely transfers the ERC-20 tokens.