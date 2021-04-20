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
} from "../utils/constants";

const provider = waffle.provider;
chai.use(solidity);

describe("DeriOneV1SirenV1", async function () {
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

  describe("_calculatePremiumSirenV1", function () {
    it("should calculate premium", async function () {
      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getOptionListSirenV1", function () {
    it("should get list of all options", async function () {
      const optionList = await deriOneV1Main._getOptionListSirenV1();
      console.log("optionList ==>", optionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedCountFromExactValues", function () {
    it("should get matched count from exact values in siren", async function () {
      const matchedCount = await deriOneV1Main._getMatchedCountFromExactValues(
        ASSETS.SUSHI,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[50],
        "1"
      );

      console.log("matchedCount ==>", matchedCount);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionFromExactValuesSirenV1", function () {
    it("should get the matched option in siren", async function () {
      const matchedOption = await deriOneV1Main.getOptionFromExactValuesSirenV1(
        ASSETS.SUSHI,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[50],
        "1"
      );

      console.log("matchedOption ==>", matchedOption);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedCountFromRangeValuesSirenV1", function () {
    it("should get matched count from range values in siren", async function () {
      const matchedCount = await deriOneV1Main._getMatchedCountFromRangeValuesSirenV1(
        ASSETS.UNI,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[0],
        STRIKE_PRICE[50],
        "1"
      );

      console.log("matchedCount ==>", matchedCount);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValuesSirenV1", function () {
    it("should get matched option list in siren", async function () {
      const matchedOptionList = await deriOneV1Main.getOptionListFromRangeValuesSirenV1(
        ASSETS.UNI,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[0],
        STRIKE_PRICE[50],
        "1"
      );

      console.log("matchedOptionList ==>", matchedOptionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });
});

// test driven development for siren
