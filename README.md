# Motivation

On Dec 1st(2020), I found that the put option in Hegic was so much more expensive than the one in Opyn. In Hegic, it cost about **$57** to buy a 1 ETH put option with the strike price of $360(expiry is 21 days.) Whereas, in Opyn, it cost about **$2.5** to buy a 1 ETH put option with the strike price of $360(expiry is about 24days.)

It'd be useful to get the best option price across options protocols both for investors and developers.

Each protocol has a different mechanism, contract structure and interface. It's a challenge for us to come up with a simple solution and keep upgrading our code.

# What This Contract Does

In this first version, I keep a function minimal. You can get the best ETH put option price from Hegic and Opyn by calling a single function.

_The logical extension of this aggregator would be expanding to other derivatives like swaps, futures and forwards._

# Setup

1. create a `.env` file like below:

   ```
   INFURA_API_KEY =
   DEPLOYMENT_ACCOUNT_KEY =
   ```
   _\*ask for values to the team and pass them_

2. navigate to your repo directory and install the dependencies:

   ```
   npm install
   ```

# Deploy to a Local Ganache Instance That Mirrors the Mainnet

I develop with the mirrored mainnet in a local instance because it is painful to use a testnet in a cross protocol development.

1. Install the [Ganache CLI](https://github.com/trufflesuite/ganache-cli)

   ```
   npm install -g ganache-cli
   ```

2. _Fork_ and mirror the mainnet into your Ganache instance.
   You can fork the mainnet and use each protocol's production contracts and production ERC20 tokens.
   Replace `INFURA_API_KEY` with the value in the following and run:

   ```
   ganache-cli --fork https://mainnet.infura.io/v3/INFURA_API_KEY -i 1
   ```

3. In a new terminal window in your repo directory, run:

   ```
   truffle console
   ```

4. Migrate your contracts to your instance of Ganache with:

   ```
   migrate --reset
   ```

   \*After a few minutes, your contract will be deployed.

# Deploy to the Mainnet

1. Run:

   ```
   truffle console --network mainnet
   ```

2. You are now connected to the mainnet. Now, use the migrate command to deploy your contracts:

   ```
   migrate --reset
   ```

# Interact With the Contract

## Set up

Call some functions to instantiate a contract.

Call your contract's function within the truffle console.

```
truffle console --network mainnet_forking
let contractInstance = await DeriOneV1Main.at(deployedAddress)
```

If your implementation is correct, then the transaction will succeed. If it fails/reverts, a reason will be given.

\*if the above operation takes an unreasonably long time or timesout, try `CTRL+C` to exit the Truffle console, run `truffle console` again, then try this step agin. You may need to wait a few blocks before your node can 'see' the deployed contract.

# EOA Address

We are using this EOA address `0xcc84e428b30ea976f932d77293df4ba8edd7307f`.

# Known issues

## No access to archive state errors

If you are using Ganache to fork a network, then you may have issues with the blockchain archive state every 30 minutes. This is due to your node provider (i.e. Infura) only allowing free users access to 30 minutes of archive state. You can either 1) upgrade to a paid plan or 2) restart your ganache instance and redploy your contracts.

# Versions

```bash
$ truffle --version
Truffle v5.1.51
$ ganache-cli --version
Ganache CLI v6.12.1 (ganache-core: 2.13.1)
```
