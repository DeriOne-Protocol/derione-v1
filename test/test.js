const { ethers } = require("hardhat");
const { solidity } = require("ethereum-waffle");
const chai = require("chai");
chai.use(solidity);
const { waffle } = require("hardhat");
const provider = waffle.provider;

describe("DeriOneV1 contract", function () {
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
    const ETHOptionAddressHegicV888 =
      "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
    const WBTCOptionAddressHegicV888 =
      "0x3961245DB602eD7c03eECcda33eA3846bD8723BD";
    const ETHPoolAddressHegicV888 =
      "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";
    const WBTCPoolAddressHegicV888 =
      "0x20dd9e22d22dd0a6ef74a520cb08303b5fad5de7";
    const strikesRange = 100;

    deriOneV1Main = await DeriOneV1Main.deploy(
      charmV02OptionFactoryAddress,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange
    );
    console.log("deployed");

    const unsignedDeployTx = DeriOneV1Main.getDeployTransaction(
      charmV02OptionFactoryAddress,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange
    );
    let estimatedGasAmount = await provider.estimateGas(unsignedDeployTx);
    console.log("estimatedGasAmount ==>", estimatedGasAmount.toString());
  });

  describe("Check the owner", function () {
    it("Should set the right owner", async function () {
      chai.expect(await deriOneV1Main.owner()).to.equal(owner.address);
    });
  });

  describe("DeriOneV1Main contract", async function () {
    const block = await provider.getBlock();
    const timestamp = block.timestamp;

    // CALLS
    describe("getBestETHOptionFromExactValues", function () {
      it("should get the best ETH option from exact values", async function () {
        const ETHOptionList = await deriOneV1Main.getBestETHOptionFromExactValues(
          2,
          timestamp + 86400 * 14,
          90000000000, // USD price decimals are 8 in hegic
          "5000000000000000000"
        );
        console.log(
          "ETHOptionList from getBestETHOptionFromExactValues ==>",
          ETHOptionList
        );

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getBestETHOptionFromRangeValues", function () {
      it("should get the best ETH option from range values", async function () {
        const ETHOptionList = await deriOneV1Main.getBestETHOptionFromRangeValues(
          2,
          timestamp + 86400 * 14,
          70000000000, // USD price decimals are 8 in hegic
          140000000000, // USD price decimals are 8 in hegic
          "5000000000000000000"
        );
        console.log(
          "ETHOptionList from getBestETHOptionFromRangeValues ==>",
          ETHOptionList
        );

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getETHOptionListFromExactValues", function () {
      it("should get ETH options list from exact values", async function () {
        const ETHOptionList = await deriOneV1Main.getETHOptionListFromExactValues(
          2,
          timestamp + 86400 * 14,
          90000000000, // USD price decimals are 8 in hegic
          "5000000000000000000"
        );
        console.log(
          "ETHOptionList from getETHOptionListFromExactValues ==>",
          ETHOptionList
        );

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getETHOptionListFromRangeValues", function () {
      it("should get ETH options list from range values", async function () {
        const ETHOptionList = await deriOneV1Main.getETHOptionListFromRangeValues(
          0,
          2,
          timestamp + 86400 * 14,
          70000000000, // USD price decimals are 8 in hegic
          140000000000, // USD price decimals are 8 in hegic
          "5000000000000000000"
        );
        console.log(
          "ETHOptionList from getETHOptionListFromRangeValues ==>",
          ETHOptionList
        );

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    // TRANSACTIONS
    describe("Transactions", function () {});
  });

  describe("DeriOneV1CharmV02 contract", function () {
    describe("_getOptionMarketAddressList", function () {
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

    describe("_getOptionMarketList", function () {
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

    describe("_getETHMarketList", function () {
      it("should get ETH Call option market list in charm", async function () {
        const charmV02OptionMarketAddressList = await deriOneV1Main._getOptionMarketAddressList();
        const charmV02OptionMarketList = await deriOneV1Main._getOptionMarketList(
          charmV02OptionMarketAddressList
        );
        const charmV02OptionMarketETHCallList = await deriOneV1Main._getETHMarketList(
          2,
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

    describe("_calculatePremium", function () {
      it("should get premium in charm", async function () {
        const premium = await deriOneV1Main._calculatePremium(
          "5000000000000000000"
        );

        console.log("premium ==>", premium);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("_getETHOptionList", function () {
      it("should get ETH Call option list in charm", async function () {
        const charmV02ETHCallOptionList = await deriOneV1Main._getETHOptionList(
          2,
          "5000000000000000000"
        );

        console.log("charmV02ETHCallOptionList ==>", charmV02ETHCallOptionList);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getMatchedCountFromExactValues", function () {
      it("should get matched count from exact values in charm", async function () {
        const matchedCount = await deriOneV1Main.getMatchedCountFromExactValues(
          2,
          timestamp + 86400 * 14,
          "1000000000000000000000",
          "5000000000000000000"
        );

        console.log("matchedCount ==>", matchedCount);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getETHOptionFromExactValuesCharmV02", function () {
      it("should get the matched ETH option in charm", async function () {
        const matchedETHOption = await deriOneV1Main.getETHOptionFromExactValuesCharmV02(
          2,
          timestamp + 86400 * 14,
          "1000000000000000000000",
          "5000000000000000000"
        );

        console.log("matchedETHOption ==>", matchedETHOption);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getMatchedCountFromRangeValues", function () {
      it("should get matched count from range values in charm", async function () {
        const matchedCount = await deriOneV1Main.getMatchedCountFromRangeValues(
          2,
          timestamp + 86400 * 14,
          "800000000000000000000", // what are decimals here?
          "1200000000000000000000",
          "5000000000000000000"
        );

        console.log("matchedCount ==>", matchedCount);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getETHOptionListFromRangeValuesCharmV02", function () {
      it("should get ETH Call matched option list in charm", async function () {
        const charmV02MatchedETHCallOptionList = await deriOneV1Main.getETHOptionListFromRangeValuesCharmV02(
          2,
          timestamp + 86400 * 14,
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
  });

  describe("DeriOneV1HegicV888 contract", function () {
    describe("updateStrikesStandard", function () {
      it("should update the strikes standard in a storage", async function () {
        await deriOneV1Main.updateStrikesStandard(200);

        console.log(" ==>");

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("hasEnoughLiquidityHegicV888", function () {
      it("should check ETH liquidity in Hegic V888", async function () {
        const hasEnoughETHLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
          0,
          "5000000000000000000"
        );

        console.log("hasEnoughETHLiquidity ==>", hasEnoughETHLiquidity);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("hasEnoughLiquidityHegicV888", function () {
      it("should check WBTC liquidity in Hegic V888", async function () {
        const hasEnoughWBTCLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
          1,
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
          0,
          2,
          86400 * 14, // two weeks from now
          180000000000,
          "5000000000000000000"
        );

        console.log("protocol ==>", ETHOption.protocol);
        console.log("underlyingAsset ==>", ETHOption.underlyingAsset);
        console.log("optionType ==>", ETHOption.optionType);
        console.log(
          "expiryTimestamp ==>",
          ETHOption.expiryTimestamp.toString()
        );
        console.log("strikeUSD ==>", ETHOption.strikeUSD.toString());
        console.log("size ==>", ETHOption.size.toString());
        console.log("premium ==>", ETHOption.premium.toString());

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("getOptionFromExactValuesHegicV888", function () {
      it("should get a WBTC option from exact values", async function () {
        const WBTCOption = await deriOneV1Main.getOptionFromExactValuesHegicV888(
          1,
          2,
          86400 * 14, // two weeks from now
          5200000000000,
          "500000000"
        );

        console.log("protocol ==>", WBTCOption.protocol);
        console.log("underlyingAsset ==>", WBTCOption.underlyingAsset);
        console.log("optionType ==>", WBTCOption.optionType);
        console.log(
          "expiryTimestamp ==>",
          WBTCOption.expiryTimestamp.toString()
        );
        console.log("strikeUSD ==>", WBTCOption.strikeUSD.toString());
        console.log("size ==>", WBTCOption.size.toString());
        console.log("premium ==>", WBTCOption.premium.toString());

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("_constructOptionStandardList", function () {
      it("should get ETH option standard list", async function () {
        const ETHOptionStandardList = await deriOneV1Main._constructOptionStandardList(
          0
        );

        console.log(" ETHOptionStandardList ==>", ETHOptionStandardList);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("_constructOptionStandardList", function () {
      it("should get WBTC option standard list", async function () {
        const WBTCOptionStandardList = await deriOneV1Main._constructOptionStandardList(
          1
        );

        console.log(" WBTCOptionStandardList ==>", WBTCOptionStandardList);

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("_getMatchedOptionList ETH", function () {
      it("should get the matched ETH option list", async function () {
        const optionStandardList = await deriOneV1Main._constructOptionStandardList(
          0
        );
        const matchedETHOptionList = await deriOneV1Main._getMatchedOptionList(
          0,
          2,
          timestamp + 86400 * 14,
          80000000000,
          120000000000,
          "5000000000000000000",
          optionStandardList
        );

        console.log("matchedETHOptionList ==>", matchedETHOptionList);
        // console.log("protocol ==>", matchedETHOptionList.protocol);
        // console.log("underlyingAsset ==>", matchedETHOptionList.underlyingAsset);
        // console.log("optionType ==>", matchedETHOptionList.optionType);
        // console.log(
        //   "expiryTimestamp ==>",
        //   matchedETHOptionList.expiryTimestamp.toString()
        // );
        // console.log("strikeUSD ==>", matchedETHOptionList.strikeUSD.toString());
        // console.log("size ==>", matchedETHOptionList.size.toString());
        // console.log("premium ==>", matchedETHOptionList.premium.toString());

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });

    describe("_getMatchedOptionList WBTC", function () {
      it("should get the matched WBTC option list", async function () {
        const optionStandardList = await deriOneV1Main._constructOptionStandardList(
          1
        );
        const matchedWBTCOptionList = await deriOneV1Main._getMatchedOptionList(
          1,
          2,
          timestamp + 86400 * 14,
          80000000000,
          120000000000,
          "5000000000000000000",
          optionStandardList
        );

        console.log("matchedWBTCOptionList ==>", matchedWBTCOptionList);

        // console.log("protocol ==>", matchedWBTCOptionList.protocol);
        // console.log(
        //   "underlyingAsset ==>",
        //   matchedWBTCOptionList.underlyingAsset
        // );
        // console.log("optionType ==>", matchedWBTCOptionList.optionType);
        // console.log(
        //   "expiryTimestamp ==>",
        //   matchedWBTCOptionList.expiryTimestamp.toString()
        // );
        // console.log(
        //   "strikeUSD ==>",
        //   matchedWBTCOptionList.strikeUSD.toString()
        // );
        // console.log("size ==>", matchedWBTCOptionList.size.toString());
        // console.log("premium ==>", matchedWBTCOptionList.premium.toString());

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8418").to.be
          .properAddress;
      });
    });

    describe("getOptionListFromRangeValuesHegicV888", function () {
      it("should get the matched option list", async function () {
        const optionList = await deriOneV1Main.getOptionListFromRangeValuesHegicV888(
          0,
          2,
          timestamp + 86400 * 14,
          80000000000,
          120000000000,
          "5000000000000000000"
        );

        chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
          .properAddress;
      });
    });
  });
});

// program expiry time. don't change it manually.
