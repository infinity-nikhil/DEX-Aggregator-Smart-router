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