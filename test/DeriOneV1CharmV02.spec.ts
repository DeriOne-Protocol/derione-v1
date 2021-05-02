import chai, { expect } from "chai";
import { solidity } from "ethereum-waffle";
import { ethers, waffle } from "hardhat";
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

describe("DeriOneV1CharmV02", async function () {
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

  describe("_getAllOptionMarketAddresses", function () {
    it("should get option market address list in charm v02", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      console.log(
        "optionMarketAddressListCharmV02 ==>",
        optionMarketAddressListCharmV02
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getAllOptionMarkets", function () {
    it("should get option market list in charm v02", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      console.log("charmV02OptionMarketList ==>", charmV02OptionMarketList);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_filterMarketWithAssetAndType", async function () {
    it("should get a market list(an array of the option struct) of ETH call in Charm", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      const charmV02OptionMarketETHCallList = await deriOneV1Main._filterMarketWithAssetAndType(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        charmV02OptionMarketList
      );
      await expect(charmV02OptionMarketETHCallList.baseToken()).to.be.equal(
        "0x"
      );
      await expect(charmV02OptionMarketETHCallList.isPut()).to.be.equal(false);
    });
    it("should get a market list(an array of the option struct) of ETH put in Charm", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      const charmV02OptionMarketETHPutList = await deriOneV1Main._filterMarketWithAssetAndType(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Put,
        charmV02OptionMarketList
      );
      await expect(charmV02OptionMarketETHPutList.baseToken()).to.be.equal(
        "0x"
      );
      await expect(charmV02OptionMarketETHPutList.isPut()).to.be.equal(true);
    });

    it("should get a market list(an array of the option struct) of WBTC call in Charm", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      const charmV02OptionMarketWBTCCallList = await deriOneV1Main._filterMarketWithAssetAndType(
        ASSET_NAMES.WBTC,
        OPTION_TYPE_NAMES.Call,
        charmV02OptionMarketList
      );
      await expect(charmV02OptionMarketWBTCCallList.baseToken()).to.be.equal(
        "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
      );
      await expect(charmV02OptionMarketWBTCCallList.isPut()).to.be.equal(false);
    });

    it("should get a market list(an array of the option struct) of WBTC put in Charm", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      const charmV02OptionMarketWBTCPutList = await deriOneV1Main._filterMarketWithAssetAndType(
        ASSET_NAMES.WBTC,
        OPTION_TYPE_NAMES.Put,
        charmV02OptionMarketList
      );
      await expect(charmV02OptionMarketWBTCPutList.baseToken()).to.be.equal(
        "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
      );
      await expect(charmV02OptionMarketWBTCPutList.isPut()).to.be.equal(true);
    });

    it("should fail to get a market list for a non-existent option type", async function () {
      const optionMarketAddressListCharmV02 = await deriOneV1Main._getAllOptionMarketAddresses();
      const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
        optionMarketAddressListCharmV02
      );
      await expect(
        deriOneV1Main._filterMarketWithAssetAndType(
          ASSET_NAMES.Invalid,
          OPTION_TYPE_NAMES.Invalid,
          charmV02OptionMarketList
        )
      ).to.be.revertedWith("wrong arguments value");
    });
  });

  describe("_calculatePremiumCharmV02", function () {
    it("should get premium in charm", async function () {
      const premium = await deriOneV1Main._calculatePremiumCharmV02(
        OPTION_SIZE[5]
      );

      console.log("premium ==>", premium);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getOptionListCharmV02", function () {
    it("should get ETH Call option list in charm", async function () {
      const ETHCallOptionListCharmV02 = await deriOneV1Main._getOptionListCharmV02(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        OPTION_SIZE[5]
      );

      console.log("ETHCallOptionListCharmV02 ==>", ETHCallOptionListCharmV02);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getMatchedCountFromExactValuesCharmV02", function () {
    it("should get matched count from exact values in charm", async function () {
      const matchedCount = await deriOneV1Main.getMatchedCountFromExactValuesCharmV02(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[3000],
        OPTION_SIZE[5]
      );

      console.log("matchedCount ==>", matchedCount);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionFromExactValuesCharmV02", function () {
    it("should get the matched ETH Call option in charm", async function () {
      const matchedETHCallOption = await deriOneV1Main.getOptionFromExactValuesCharmV02(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[3000],
        OPTION_SIZE[5]
      );

      console.log("matchedETHCallOption ==>", matchedETHCallOption);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("_getMatchedCountFromRangeValuesCharmV02", function () {
    it("should get matched count from range values in charm v02", async function () {
      const matchedCount = await deriOneV1Main.getMatchedCountFromRangeValues(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400],
        STRIKE_PRICE[5000],
        OPTION_SIZE[5]
      );

      console.log("matchedCount ==>", matchedCount);

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });

  describe("getOptionListFromRangeValuesCharmV02", function () {
    it("should get ETH Call matched option list in charm v02", async function () {
      const matchedETHCallOptionListCharmV02 = await deriOneV1Main.getOptionListFromRangeValuesCharmV02(
        ASSET_NAMES.ETH,
        OPTION_TYPE_NAMES.Call,
        TIMESTAMP.fourMonth,
        STRIKE_PRICE[400], // what are decimals here?
        STRIKE_PRICE[5000],
        OPTION_SIZE[5]
      );

      console.log(
        "matchedETHCallOptionListCharmV02 ==>",
        matchedETHCallOptionListCharmV02
      );

      chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
        .properAddress;
    });
  });
});
