# Crypto Gambling Smart Contract

The idea is that if you deploy this smart contract, participants can bet on the price of Ethereum
If the price goes higher as of the time the bet was closed -- betting should ideally start in the morning and stop in the evening but since it's flexible, anytime that's specified is will work.
- We use chainlink to get Ethereum current price
- Every participant can withraw their funds with their initial investment. If all participants make predict correctly they will be nothing to benefit as participants benefits from others wrong guess.
- If participant predicts wrongly, they lose everything.
- It's gambling. It's not business.

This is a work in progress. 

## Short comings
- It's currently dividing the profit by all the participants instead of only the participants that guess right, leaving some funds that no one gets to claim.
- Need to be able to get the total number of participants who were successful and those who lose without loops.