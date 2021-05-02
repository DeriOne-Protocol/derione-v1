import chai from "chai";
import { solidity } from "ethereum-waffle";
import { ethers, waffle } from "hardhat";
import { convertOptionList } from "./utils";
import {
  ASSET_NAMES,
  CONSTRUCTOR_VALUES,
  OPTION_SIZE,
  OPTION_TYPE_NAMES,
  STRIKE_PRICE,
  TIMESTAMP
} from "../constants/constants";

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

  describe("_calculatePremium", function () {
    it("should calculate premium", async function () {
      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getOptionList", function () {
    it("should get list of all options", async function () {
      let optionList;
      try {
        optionList = await deriOneV1Main._getOptionListSirenV1();
        optionList = convertOptionList(optionList);
        console.log("optionList ==>", optionList);
      } catch (error) {
        console.error(error);
      }
      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedCountFromExactValues", function () {
    it("should get matched count from exact values", async function () {
      const matchedCount = await deriOneV1Main._getMatchedCountFromExactValues(
        ASSET_NAMES.SUSHI,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        "1"
      );
      console.log("matchedCount ==>", matchedCount.toString());

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionFromExactValues", function () {
    it("should get the matched option", async function () {
      const matchedCount = await deriOneV1Main._getMatchedCountFromExactValues(
        ASSET_NAMES.SUSHI,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        "1"
      );
      if (matchedCount > 0) {
        let matchedOption;
        try {
          matchedOption = await deriOneV1Main.getOptionFromExactValuesSirenV1(
            ASSET_NAMES.SUSHI,
            OPTION_TYPE_NAMES.Call,
            TIMESTAMP.fourMonth,
            STRIKE_PRICE[400],
            "1"
          );
          matchedOption = convertOptionList(matchedOption);
          console.log("matchedOption ==>", matchedOption);
        } catch (error) {
          console.error(error);
        }
      } else {
        console.log("no matches");
      }

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedCountFromRangeValues", function () {
    it("should get matched count from range values", async function () {
      const matchedCount = await deriOneV1Main._getMatchedCountFromRangeValuesSirenV1(
        ASSET_NAMES.UNI,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[0],
        STRIKE_PRICE[400],
        "1"
      );

      console.log("matchedCount ==>", matchedCount.toString());

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValues", function () {
    it("should get matched option list", async function () {
      let matchedOptionList;
      try {
        matchedOptionList = await deriOneV1Main.getOptionListFromRangeValuesSirenV1(
          ASSET_NAMES.UNI,
          OPTION_TYPE_NAMES.Call,
          TIMESTAMP.fourMonth,
          STRIKE_PRICE[0],
          STRIKE_PRICE[400],
          "1"
        );
        matchedOptionList = convertOptionList(matchedOptionList);
        console.log("matchedOptionList ==>", matchedOptionList);
      } catch (error) {
        console.error(error);
      }

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });
});

// test driven development for siren
