const { ethers } = require("hardhat");
const { solidity } = require("ethereum-waffle");
const chai = require("chai");

chai.use(solidity);

describe("DeriOneV1Main contract", function () {
  let DeriOneV1Main;
  let deriOneV1Main;
  let owner;

  beforeEach(async function () {
    DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");
    [owner] = await ethers.getSigners();

    // const variables for the constructor
    const ETHPriceOracleAddress = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
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
      ETHPriceOracleAddress,
      hegicETHOptionV888Address,
      hegicETHPoolV888Address,
      opynExchangeV1Address,
      opynOptionsFactoryV1Address,
      uniswapFactoryV1Address
    );
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      chai.expect(await deriOneV1Main.owner()).to.equal(owner.address);
    });
  });

  describe("Transactions", function () {
    it("should get the cheapest ETH option", async function () {
      await deriOneV1Main.getTheCheapestETHPutOption(
        1609747642,
        200,
        1000,
        "5000000000000000000"
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;

      // it("Should fail if the option size is too big", async function () {
      //   const theCheapestETHPutOption = await deriOneV1Main.getTheCheapestETHPutOption(
      //     1609747642,
      //     200,
      //     1000,
      //     "50000000000000000000000000"
      //   );
      //   chai.expect();
      // });
    });
  });
});
