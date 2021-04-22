import chai from "chai";
import { solidity } from "ethereum-waffle";
import { ethers, waffle } from "hardhat";
import {
  ASSETS,
  CONSTRUCTOR_VALUES,
  OPTION_SIZE,
  OPTION_TYPES,
  STRIKE_PRICE,
  TIMESTAMP
} from "../constants/constants";

const provider = waffle.provider;
chai.use(solidity);

describe("DeriOneV1Main", async function () {
  const [wallet] = provider.getWallets();
  console.log("wallet.address ==>", wallet.address);

  let DeriOneV1Main;
  let deriOneV1Main;

  before(async function () {
    DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

    const {
      optionFactoryAddressCharmV02,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange,
      ammAddressListSirenV1
    } = CONSTRUCTOR_VALUES;

    deriOneV1Main = await DeriOneV1Main.deploy(
      optionFactoryAddressCharmV02,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange,
      ammAddressListSirenV1
    );
    console.log("deployed");

    const unsignedDeployTx = DeriOneV1Main.getDeployTransaction(
      optionFactoryAddressCharmV02,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange,
      ammAddressListSirenV1
    );
    let estimatedGasAmount = await provider.estimateGas(unsignedDeployTx);
    console.log("estimatedGasAmount ==>", estimatedGasAmount.toString());
  });

  describe("Check the owner", function () {
    it("Should set the right owner", async function () {
      let owner;
      [owner] = await ethers.getSigners();
      chai.expect(await deriOneV1Main.owner()).to.equal(owner.address);
    });
  });

  // CALLS
  describe("getBestOptionFromExactValues", function () {
    it("should get the best ETH Put option from exact values", async function () {
      const bestETHPutOption = await deriOneV1Main.getBestOptionFromExactValues(
        ASSETS.ETH,
        OPTION_TYPES.Put,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[3000],
        OPTION_SIZE[5]
      );
      console.log(
        "bestETHPutOption from getBestOptionFromExactValues ==>",
        bestETHPutOption
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getBestOptionFromRangeValues", function () {
    it("should get the best WBTC Put option from range values", async function () {
      const bestWBTCPutOption = await deriOneV1Main.getBestOptionFromRangeValues(
        ASSETS.WBTC,
        OPTION_TYPES.Put,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        OPTION_SIZE[5]
      );
      console.log(
        "bestWBTCPutOption from getBestOptionFromRangeValues ==>",
        bestWBTCPutOption
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromExactValues", function () {
    it("should get WBTC Call options list from exact values", async function () {
      const WBTCCallOptionList = await deriOneV1Main.getOptionListFromExactValues(
        ASSETS.WBTC,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[3000],
        OPTION_SIZE[5]
      );
      console.log(
        "WBTCCallOptionList from getOptionListFromExactValues ==>",
        WBTCCallOptionList
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValues", function () {
    it("should get ETH call options list from range values", async function () {
      const ETHCallOptionList = await deriOneV1Main.getOptionListFromRangeValues(
        ASSETS.ETH,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        OPTION_SIZE[1]
      );
      console.log(
        "ETHCallOptionList from getOptionListFromRangeValues ==>",
        ETHCallOptionList
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  // TRANSACTIONS;
  describe("Buy the best option", function () {});
});

// integrate before section into a single file
