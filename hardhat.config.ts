import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import dotenv from "dotenv";
dotenv.config();

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
        // url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
        blockNumber: 12274463 // use the same block number to make subsequent runs faster with cache.
      },
      gas: "auto", // gasLimit
      gasPrice: 229000000000, // check the latest gas price market in https://www.ethgasstation.info/
      // inject: false, // optional. If true, it will EXPOSE your mnemonic in your frontend code. Then it would be available as an "in-page browser wallet" / signer which can sign without confirmation.
      accounts: {
        mnemonic: process.env.MNEMONIC_WORDS
      }
    },
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      // url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [`0x${process.env.DEPLOYMENT_ACCOUNT_PRIVATE_KEY}`],
      gas: "auto", // gasLimit
      gasPrice: 41000000000 // check the latest gas price market in https://www.ethgasstation.info/
      // inject: false, // optional. If true, it will EXPOSE your mnemonic in your frontend code. Then it would be available as an "in-page browser wallet" / signer which can sign without confirmation.
    }
  },
  solidity: {
    version: "0.6.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    // spec: "./test/**/*.spec.js",
    timeout: 2000000
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};
