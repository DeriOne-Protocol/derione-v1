const { ethers } = require("hardhat");
const { solidity } = require("ethereum-waffle");
const chai = require("chai");
chai.use(solidity);
const { waffle } = require("hardhat");
const provider = waffle.provider;

describe("DeriOneV1Main contract", function () {
  let owner;
  let DeriOneV1Main;
  let deriOneV1Main;

  beforeEach(async function () {
    // the owner is the account that makes deployment
    [owner] = await ethers.getSigners();

    DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

    // const variables for the constructor
    const hegicETHOptionV888Address =
      "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
    const hegicETHPoolV888Address =
      "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";
    const opynExchangeV1Address = "0x39246c4f3f6592c974ebc44f80ba6dc69b817c71";
    const opynOptionsFactoryV1Address =
      "0xcc5d905b9c2c8c9329eb4e25dc086369d6c7777c";
    const uniswapFactoryV1Address =
      "0xc0a47dfe034b400b47bdad5fecda2621de6c4d95";

    deriOneV1Main = await DeriOneV1Main.deploy(
      hegicETHOptionV888Address,
      hegicETHPoolV888Address,
      opynExchangeV1Address,
      opynOptionsFactoryV1Address,
      uniswapFactoryV1Address
    );
    console.log("deployed");

    const unsignedDeployTx = DeriOneV1Main.getDeployTransaction(
      hegicETHOptionV888Address,
      hegicETHPoolV888Address,
      opynExchangeV1Address,
      opynOptionsFactoryV1Address,
      uniswapFactoryV1Address
    );
    let estimatedGasAmount = await provider.estimateGas(unsignedDeployTx);
    console.log("estimatedGasAmount ==>", estimatedGasAmount.toString());
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      chai.expect(await deriOneV1Main.owner()).to.equal(owner.address);
    });
  });

  describe("Transactions", function () {
    it("should get the cheapest ETH option", async function () {
      const theCheapestETHPutOption = await deriOneV1Main.callStatic.getTheCheapestETHPutOption(
        24 * 3600, // 24 hours from now in seconds
        80000000000, // USD price decimals are 8 in hegic
        90000000000, // USD price decimals are 8 in hegic
        "5000000000000000000"
      );
      console.log("theCheapestETHPutOption ==>", theCheapestETHPutOption);

      await deriOneV1Main.getTheCheapestETHPutOption(
        24 * 3600, // 24 hours from now in seconds
        80000000000, // USD price decimals are 8 in hegic
        90000000000, // USD price decimals are 8 in hegic
        "5000000000000000000"
      );
      const theCheapestETHPutOptionTx = await deriOneV1Main.theCheapestETHPutOption();
      console.log("theCheapestETHPutOptionTx ==>", theCheapestETHPutOptionTx);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });
});
