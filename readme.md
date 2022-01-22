# Crypto Gambling Smart Contract

The idea is that if you deploy this smart contract, participants can bet on the price of Ethereum, whether it will go up or down.
If the price goes up those who said it will go up from the opening price will become winners while those who predict it will go down will lose.
Each participant will set a price they believe it will get to and go above.

- We use chainlink to get Ethereum current price
- Every participant can withraw their funds with their initial investment. If all participants make predict correctly they will be nothing to benefit as participants benefit from others wrong guesses.
- If participants predicts wrongly, they lose everything.
- It's gambling. It's not business.


## Short comings
- It's currently dividing the profit by all the participants instead of only the participants that guess right, leaving some funds that no one gets to claim.
- Need to be able to get the total number of participants who were successful and those who lose without using loops.

## *Disclaimer*: 
Cryptocurrency transactions comes with risks. Sometimes, funds can get lost and are unrecoverable. If you are going to try this or any other contract make sure you test it on the testnet sufficiently. 
I am not responsible for any loss of funds. This is for educational/entertainment purpose only.