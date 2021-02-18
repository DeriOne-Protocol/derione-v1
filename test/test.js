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

  before(async function () {
    // the owner is the account that makes deployment
    [owner] = await ethers.getSigners();

    DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

    // const variables for the constructor
    const charmV02OptionFactoryAddress =
      "0x443ec3dc7840c3eb610a2a80068dfe3c56822e86";
    const hegicETHOptionV888Address =
      "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
    const hegicETHPoolV888Address =
      "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";

    deriOneV1Main = await DeriOneV1Main.deploy(
      charmV02OptionFactoryAddress,
      hegicETHOptionV888Address,
      hegicETHPoolV888Address
    );
    console.log("deployed");

    const unsignedDeployTx = DeriOneV1Main.getDeployTransaction(
      charmV02OptionFactoryAddress,
      hegicETHOptionV888Address,
      hegicETHPoolV888Address
    );
    let estimatedGasAmount = await provider.estimateGas(unsignedDeployTx);
    console.log("estimatedGasAmount ==>", estimatedGasAmount.toString());
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      chai.expect(await deriOneV1Main.owner()).to.equal(owner.address);
    });
  });

  describe("Calls", function () {
    it("should get option market address list in charm", async function () {
      const charmV02OptionMarketAddressList = await deriOneV1Main._getOptionMarketAddressList();
      console.log(
        "charmV02OptionMarketAddressList ==>",
        charmV02OptionMarketAddressList
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Calls", function () {
    it("should get option market list in charm", async function () {
      const charmV02OptionMarketAddressList = await deriOneV1Main._getOptionMarketAddressList();
      const charmV02OptionMarketList = await deriOneV1Main._getOptionMarketList(
        charmV02OptionMarketAddressList
      );
      console.log("charmV02OptionMarketList ==>", charmV02OptionMarketList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Calls", function () {
    it("should get ETH Call option market list in charm", async function () {
      const charmV02OptionMarketAddressList = await deriOneV1Main._getOptionMarketAddressList();
      const charmV02OptionMarketList = await deriOneV1Main._getOptionMarketList(
        charmV02OptionMarketAddressList
      );
      const charmV02OptionMarketETHCallList = await deriOneV1Main._getETHCallMarketList(
        charmV02OptionMarketList
      );
      console.log(
        "charmV02OptionMarketETHCallList ==>",
        charmV02OptionMarketETHCallList
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Calls", function () {
    it("should get ETH Call option list in charm", async function () {
      const charmV02ETHCallOptionList = await deriOneV1Main._getETHCallOptionList();

      console.log("charmV02ETHCallOptionList ==>", charmV02ETHCallOptionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Calls", function () {
    it("should get ETH Call matched option list in charm", async function () {
      const charmV02MatchedETHCallOptionList = await deriOneV1Main.getMatchedOptionListCharmV02(
        1611907565, // 2021-01-29 08:06:05
        1613029394, // 2021-02-11 07:43:14
        "800000000000000000000", // what are decimals here?
        "1200000000000000000000",
        "5000000000000000000"
      );

      console.log(
        "charmV02MatchedETHCallOptionList ==>",
        charmV02MatchedETHCallOptionList
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Calls", function () {
    it("should get the cheapest ETH option", async function () {
      const ETHOptionList = await deriOneV1Main.getETHOptionListFromExactValues(
        1614155977, // 2021-02-24 08:39:37
        90000000000, // USD price decimals are 8 in hegic
        0,
        "5000000000000000000"
      );
      console.log("ETHOptionList ==>", ETHOptionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("Transactions", function () {});
});
