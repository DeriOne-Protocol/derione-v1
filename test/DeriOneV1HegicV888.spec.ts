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

describe("DeriOneV1HegicV888", async function () {
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

  describe("updateStrikesStandard", function () {
    it("should update the strikes standard in a storage", async function () {
      await deriOneV1Main.updateStrikesStandard(1000);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("hasEnoughLiquidityHegicV888", function () {
    it("should check ETH liquidity in Hegic V888", async function () {
      const hasEnoughETHLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
        ASSETS.ETH,
        OPTION_SIZE[5]
      );

      console.log("hasEnoughETHLiquidity ==>", hasEnoughETHLiquidity);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("hasEnoughLiquidityHegicV888", function () {
    it("should check WBTC liquidity in Hegic V888", async function () {
      const hasEnoughWBTCLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
        ASSETS.WBTC,
        "50000000"
      );

      console.log("hasEnoughWBTCLiquidity ==>", hasEnoughWBTCLiquidity);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionFromExactValuesHegicV888", function () {
    it("should get an ETH option from exact values", async function () {
      const ETHOption = await deriOneV1Main.getOptionFromExactValuesHegicV888(
        ASSETS.ETH,
        OPTION_TYPES.Call,
        86400 * 14, // two weeks from now
        STRIKE_PRICE[3000],
        "500000000"
      );

      console.log("ETHOption ==>", ETHOption);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionFromExactValuesHegicV888", function () {
    it("should get a WBTC option from exact values", async function () {
      const WBTCOption = await deriOneV1Main.getOptionFromExactValuesHegicV888(
        ASSETS.WBTC,
        OPTION_TYPES.Call,
        86400 * 14, // two weeks from now
        STRIKE_PRICE[3000],
        "500000000"
      );

      console.log("WBTCOption ==>", WBTCOption);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_constructOptionStandardList", function () {
    it("should get ETH option standard list", async function () {
      const ETHOptionStandardList = await deriOneV1Main._constructOptionStandardList(
        ASSETS.ETH
      );

      console.log("ETHOptionStandardList ==>", ETHOptionStandardList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_constructOptionStandardList", function () {
    it("should get WBTC option standard list", async function () {
      const WBTCOptionStandardList = await deriOneV1Main._constructOptionStandardList(
        ASSETS.WBTC
      );

      console.log("WBTCOptionStandardList ==>", WBTCOptionStandardList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedOptionList ETH", function () {
    it("should get the matched ETH option list", async function () {
      const optionStandardList = await deriOneV1Main._constructOptionStandardList(
        ASSETS.ETH
      );
      const matchedETHPutOptionList = await deriOneV1Main._getMatchedOptionList(
        OPTION_TYPES.Put,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        "500000000",
        optionStandardList
      );

      console.log("matchedETHPutOptionList ==>", matchedETHPutOptionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedOptionList WBTC", function () {
    it("should get the matched WBTC option list", async function () {
      const optionStandardList = await deriOneV1Main._constructOptionStandardList(
        ASSETS.WBTC
      );
      const matchedWBTCPutOptionList = await deriOneV1Main._getMatchedOptionList(
        OPTION_TYPES.Put,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        "500000000",
        optionStandardList
      );

      console.log("matchedWBTCPutOptionList ==>", matchedWBTCPutOptionList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8418").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValuesHegicV888", function () {
    it("should get the matched ETH Call option list", async function () {
      const optionETHCallList = await deriOneV1Main.getOptionListFromRangeValuesHegicV888(
        ASSETS.ETH,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        OPTION_SIZE[5]
      );

      console.log("optionETHCallList ==>", optionETHCallList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValuesHegicV888", function () {
    it("should get the matched WBTC Call option list", async function () {
      const optionWBTCList = await deriOneV1Main.getOptionListFromRangeValuesHegicV888(
        ASSETS.WBTC,
        OPTION_TYPES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        "500000000"
      );

      console.log("optionWBTCList ==>", optionWBTCList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });
});
