require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url:
          "https://eth-mainnet.alchemyapi.io/v2/" + process.env.ALCHEMY_API_KEY,
        // url: "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY,
        blockNumber: 11652497 // use the same block number to make subsequent runs faster with cache
      },
      gas: "auto" // gasLimit
    },
    mainnet: {
      url:
        "https://eth-mainnet.alchemyapi.io/v2/" + process.env.ALCHEMY_API_KEY,
      // url: "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY
      accounts: [`0x${process.env.DEPLOYMENT_ACCOUNT_KEY}`],
      gas: "auto", // gasLimit
    }
  },
  solidity: "0.6.0",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 2000000
  },
  etherscan: {
    apiKey: "YOUR_ETHERSCAN_API_KEY"
  }
};
