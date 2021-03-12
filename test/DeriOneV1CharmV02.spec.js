// const { solidity } = require("ethereum-waffle");
// const { ethers, waffle } = require("hardhat");
// const provider = waffle.provider;
// const chai = require("chai");
// chai.use(solidity);

// let DeriOneV1Main;
// let deriOneV1Main;

// before(async function () {
//   DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

//   // const variables for the constructor
//   const optionFactoryAddressCharmV02 =
//     "0x443ec3dc7840c3eb610a2a80068dfe3c56822e86";
//   const ETHOptionAddressHegicV888 =
//     "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
//   const WBTCOptionAddressHegicV888 =
//     "0x3961245DB602eD7c03eECcda33eA3846bD8723BD";
//   const ETHPoolAddressHegicV888 = "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";
//   const WBTCPoolAddressHegicV888 = "0x20dd9e22d22dd0a6ef74a520cb08303b5fad5de7";
//   const strikesRange = 100;

//   deriOneV1Main = await DeriOneV1Main.deploy(
//     optionFactoryAddressCharmV02,
//     ETHOptionAddressHegicV888,
//     WBTCOptionAddressHegicV888,
//     ETHPoolAddressHegicV888,
//     WBTCPoolAddressHegicV888,
//     strikesRange
//   );
//   console.log("deployed");

//   const unsignedDeployTx = DeriOneV1Main.getDeployTransaction(
//     optionFactoryAddressCharmV02,
//     ETHOptionAddressHegicV888,
//     WBTCOptionAddressHegicV888,
//     ETHPoolAddressHegicV888,
//     WBTCPoolAddressHegicV888,
//     strikesRange
//   );
//   let estimatedGasAmount = await provider.estimateGas(unsignedDeployTx);
//   console.log("estimatedGasAmount ==>", estimatedGasAmount.toString());
// });

// describe("DeriOneV1CharmV02", async function () {
//   const block = await provider.getBlock();
//   const timestamp = block.timestamp;

//   describe("_getAllOptionMarketAddresses", function () {
//     it("should get option market address list in charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       console.log(
//         "charmV02OptionMarketAddressList ==>",
//         charmV02OptionMarketAddressList
//       );

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_getAllOptionMarkets", function () {
//     it("should get option market list in charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
//         charmV02OptionMarketAddressList
//       );
//       console.log("charmV02OptionMarketList ==>", charmV02OptionMarketList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_filterMarketWithAssetAndType", async function () {
//     it("should get a market list(an array of the option struct) of ETH call in Charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
//         charmV02OptionMarketAddressList
//       );
//       const charmV02OptionMarketETHCallList = await deriOneV1Main._filterMarketWithAssetAndType(
//         0,
//         2,
//         charmV02OptionMarketList
//       );
//       await expect(charmV02OptionMarketETHCallList.baseToken()).to.be.equal(
//         "0x"
//       );
//       await expect(charmV02OptionMarketETHCallList.isPut()).to.be.equal(false);
//     });
//     it("should get a market list(an array of the option struct) of ETH put in Charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
//         charmV02OptionMarketAddressList
//       );
//       const charmV02OptionMarketETHPutList = await deriOneV1Main._filterMarketWithAssetAndType(
//         0,
//         1,
//         charmV02OptionMarketList
//       );
//       await expect(charmV02OptionMarketETHPutList.baseToken()).to.be.equal(
//         "0x"
//       );
//       await expect(charmV02OptionMarketETHPutList.isPut()).to.be.equal(true);
//     });

//     it("should get a market list(an array of the option struct) of WBTC call in Charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
//         charmV02OptionMarketAddressList
//       );
//       const charmV02OptionMarketWBTCCallList = await deriOneV1Main._filterMarketWithAssetAndType(
//         1,
//         2,
//         charmV02OptionMarketList
//       );
//       await expect(charmV02OptionMarketWBTCCallList.baseToken()).to.be.equal(
//         "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
//       );
//       await expect(charmV02OptionMarketWBTCCallList.isPut()).to.be.equal(false);
//     });

//     it("should get a market list(an array of the option struct) of WBTC put in Charm", async function () {
//       const charmV02OptionMarketAddressList = await deriOneV1Main._getAllOptionMarketAddresses();
//       const charmV02OptionMarketList = await deriOneV1Main._getAllOptionMarkets(
//         charmV02OptionMarketAddressList
//       );
//       const charmV02OptionMarketWBTCPutList = await deriOneV1Main._filterMarketWithAssetAndType(
//         1,
//         1,
//         charmV02OptionMarketList
//       );
//       await expect(charmV02OptionMarketWBTCPutList.baseToken()).to.be.equal(
//         "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
//       );
//       await expect(charmV02OptionMarketWBTCPutList.isPut()).to.be.equal(true);
//     });

//     it("should fail to get a market list for a non-existent option type", async function () {
//       await expect(
//         deriOneV1Main._filterMarketWithAssetAndType(3, charmV02OptionMarketList)
//       ).to.be.revertedWith("wrong arguments value");
//     });
//   });

//   describe("_calculatePremium", function () {
//     it("should get premium in charm", async function () {
//       const premium = await deriOneV1Main._calculatePremium(
//         "5000000000000000000"
//       );

//       console.log("premium ==>", premium);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_getOptionList", function () {
//     it("should get ETH Call option list in charm", async function () {
//       const charmV02ETHCallOptionList = await deriOneV1Main._getOptionList(
//         0,
//         2,
//         "5000000000000000000"
//       );

//       console.log("charmV02ETHCallOptionList ==>", charmV02ETHCallOptionList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getMatchedCountFromExactValues", function () {
//     it("should get matched count from exact values in charm", async function () {
//       const matchedCount = await deriOneV1Main.getMatchedCountFromExactValues(
//         0,
//         2,
//         timestamp + 86400 * 14,
//         "1000000000000000000000",
//         "5000000000000000000"
//       );

//       console.log("matchedCount ==>", matchedCount);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionFromExactValuesCharmV02", function () {
//     it("should get the matched ETH option in charm", async function () {
//       const matchedETHOption = await deriOneV1Main.getOptionFromExactValuesCharmV02(
//         0,
//         2,
//         timestamp + 86400 * 14,
//         "1000000000000000000000",
//         "5000000000000000000"
//       );

//       console.log("matchedETHOption ==>", matchedETHOption);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getMatchedCountFromRangeValues", function () {
//     it("should get matched count from range values in charm", async function () {
//       const matchedCount = await deriOneV1Main.getMatchedCountFromRangeValues(
//         0,
//         2,
//         timestamp + 86400 * 14,
//         "800000000000000000000", // what are decimals here?
//         "1200000000000000000000",
//         "5000000000000000000"
//       );

//       console.log("matchedCount ==>", matchedCount);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionListFromRangeValuesCharmV02", function () {
//     it("should get ETH Call matched option list in charm", async function () {
//       const charmV02MatchedETHCallOptionList = await deriOneV1Main.getOptionListFromRangeValuesCharmV02(
//         0,
//         2,
//         timestamp + 86400 * 14,
//         "800000000000000000000", // what are decimals here?
//         "1200000000000000000000",
//         "5000000000000000000"
//       );

//       console.log(
//         "charmV02MatchedETHCallOptionList ==>",
//         charmV02MatchedETHCallOptionList
//       );

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });
// });
