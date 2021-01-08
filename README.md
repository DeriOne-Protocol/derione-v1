# Motivation

On Dec 1st(2020), I found that the put option in Hegic was so much more expensive than the one in Opyn. In Hegic, it cost about **$57** to buy a 1 ETH put option with the strike price of $360(expiry is 21 days.) Whereas, in Opyn, it cost about **$2.5** to buy a 1 ETH put option with the strike price of $360(expiry is about 24days.)

It'd be useful to get the best option price across options protocols both for investors and developers.

Each protocol has a different mechanism, contract structure and interface. It's a challenge for us to come up with a simple solution and keep upgrading our code.

# What This Contract Does

In this first version, I keep a function minimal. You can get the best ETH put option price from Hegic and Opyn by calling a single function.

_The logical extension of this aggregator would be expanding to other derivatives like swaps, futures and forwards._
