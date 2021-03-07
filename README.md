The first version is deployed to [`0x1604AC39a9e19Fb8c1D8ccF3EC42e80D69f4d400`](https://etherscan.io/tx/0x404cf70bda1cca4e7519579c0e601b112eb88b29f2d0df5faa59f43c4ccb83ab).

# Motivation

Last December, I found that the put option in Opyn was much cheaper than the one in Hegic. In Opyn, it cost about **$2.5** to buy a 1 ETH put option with the strike price of $360(expiry is about 24days.) Whereas, in Hegic, it cost about **$57** to buy a 1 ETH put option with the strike price of $360(expiry is 21 days.)

There are more than ten options protocols as of today. Since each protocol could have different liquidity, a unique pricing formula, and a source of volatility, it'd be useful to get the best option(s) across options protocols both for traders and developers. On top of these protocols, we will aggregate options from the secondary market like H2M as well.

# What This Contract Does

In this version, you can get the best ETH option(s) from Charm V02 and Hegic V888. We will add more protocols, types and assets over time.

_The logical extension of this aggregator would be expanding to other derivatives like swaps, futures and forwards._

# Testing

You need to update the blockNumber in the hardhat config file sometimes. Otherwise, you might get the wrong values in testing.

