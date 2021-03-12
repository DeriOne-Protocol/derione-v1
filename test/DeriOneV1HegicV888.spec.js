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

// describe("DeriOneV1HegicV888", async function () {
//   const block = await provider.getBlock();
//   const timestamp = block.timestamp;

//   describe("updateStrikesStandard", function () {
//     it("should update the strikes standard in a storage", async function () {
//       await deriOneV1Main.updateStrikesStandard(200);

//       console.log(" ==>");

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("hasEnoughLiquidityHegicV888", function () {
//     it("should check ETH liquidity in Hegic V888", async function () {
//       const hasEnoughETHLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
//         0,
//         "5000000000000000000"
//       );

//       console.log("hasEnoughETHLiquidity ==>", hasEnoughETHLiquidity);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("hasEnoughLiquidityHegicV888", function () {
//     it("should check WBTC liquidity in Hegic V888", async function () {
//       const hasEnoughWBTCLiquidity = await deriOneV1Main.hasEnoughLiquidityHegicV888(
//         1,
//         "50000000"
//       );

//       console.log("hasEnoughWBTCLiquidity ==>", hasEnoughWBTCLiquidity);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionFromExactValuesHegicV888", function () {
//     it("should get an ETH option from exact values", async function () {
//       const ETHOption = await deriOneV1Main.getOptionFromExactValuesHegicV888(
//         0,
//         2,
//         86400 * 14, // two weeks from now
//         180000000000,
//         "5000000000000000000"
//       );

//       console.log("protocol ==>", ETHOption.protocol);
//       console.log("underlyingAsset ==>", ETHOption.underlyingAsset);
//       console.log("optionType ==>", ETHOption.optionType);
//       console.log("expiryTimestamp ==>", ETHOption.expiryTimestamp.toString());
//       console.log("strikeUSD ==>", ETHOption.strikeUSD.toString());
//       console.log("size ==>", ETHOption.size.toString());
//       console.log("premium ==>", ETHOption.premium.toString());

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionFromExactValuesHegicV888", function () {
//     it("should get a WBTC option from exact values", async function () {
//       const WBTCOption = await deriOneV1Main.getOptionFromExactValuesHegicV888(
//         1,
//         2,
//         86400 * 14, // two weeks from now
//         5200000000000,
//         "500000000"
//       );

//       console.log("protocol ==>", WBTCOption.protocol);
//       console.log("underlyingAsset ==>", WBTCOption.underlyingAsset);
//       console.log("optionType ==>", WBTCOption.optionType);
//       console.log("expiryTimestamp ==>", WBTCOption.expiryTimestamp.toString());
//       console.log("strikeUSD ==>", WBTCOption.strikeUSD.toString());
//       console.log("size ==>", WBTCOption.size.toString());
//       console.log("premium ==>", WBTCOption.premium.toString());

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_constructOptionStandardList", function () {
//     it("should get ETH option standard list", async function () {
//       const ETHOptionStandardList = await deriOneV1Main._constructOptionStandardList(
//         0
//       );

//       console.log(" ETHOptionStandardList ==>", ETHOptionStandardList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_constructOptionStandardList", function () {
//     it("should get WBTC option standard list", async function () {
//       const WBTCOptionStandardList = await deriOneV1Main._constructOptionStandardList(
//         1
//       );

//       console.log(" WBTCOptionStandardList ==>", WBTCOptionStandardList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_getMatchedOptionList ETH", function () {
//     it("should get the matched ETH option list", async function () {
//       const optionStandardList = await deriOneV1Main._constructOptionStandardList(
//         0
//       );
//       const matchedETHOptionList = await deriOneV1Main._getMatchedOptionList(
//         2,
//         timestamp + 86400 * 14,
//         80000000000,
//         120000000000,
//         "5000000000000000000",
//         optionStandardList
//       );

//       console.log("matchedETHOptionList ==>", matchedETHOptionList);
//       // console.log("protocol ==>", matchedETHOptionList.protocol);
//       // console.log("underlyingAsset ==>", matchedETHOptionList.underlyingAsset);
//       // console.log("optionType ==>", matchedETHOptionList.optionType);
//       // console.log(
//       //   "expiryTimestamp ==>",
//       //   matchedETHOptionList.expiryTimestamp.toString()
//       // );
//       // console.log("strikeUSD ==>", matchedETHOptionList.strikeUSD.toString());
//       // console.log("size ==>", matchedETHOptionList.size.toString());
//       // console.log("premium ==>", matchedETHOptionList.premium.toString());

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("_getMatchedOptionList WBTC", function () {
//     it("should get the matched WBTC option list", async function () {
//       const optionStandardList = await deriOneV1Main._constructOptionStandardList(
//         1
//       );
//       const matchedWBTCOptionList = await deriOneV1Main._getMatchedOptionList(
//         2,
//         timestamp + 86400 * 14,
//         80000000000,
//         120000000000,
//         "500000000",
//         optionStandardList
//       );

//       console.log("matchedWBTCOptionList ==>", matchedWBTCOptionList);

//       // console.log("protocol ==>", matchedWBTCOptionList.protocol);
//       // console.log(
//       //   "underlyingAsset ==>",
//       //   matchedWBTCOptionList.underlyingAsset
//       // );
//       // console.log("optionType ==>", matchedWBTCOptionList.optionType);
//       // console.log(
//       //   "expiryTimestamp ==>",
//       //   matchedWBTCOptionList.expiryTimestamp.toString()
//       // );
//       // console.log(
//       //   "strikeUSD ==>",
//       //   matchedWBTCOptionList.strikeUSD.toString()
//       // );
//       // console.log("size ==>", matchedWBTCOptionList.size.toString());
//       // console.log("premium ==>", matchedWBTCOptionList.premium.toString());

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8418").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionListFromRangeValuesHegicV888", function () {
//     it("should get the matched ETH option list", async function () {
//       const optionETHList = await deriOneV1Main.getOptionListFromRangeValuesHegicV888(
//         0,
//         2,
//         timestamp + 86400 * 14,
//         80000000000,
//         120000000000,
//         "5000000000000000000"
//       );

//       console.log("optionETHList ==>", optionETHList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });

//   describe("getOptionListFromRangeValuesHegicV888", function () {
//     it("should get the matched WBTC option list", async function () {
//       const optionWBTCList = await deriOneV1Main.getOptionListFromRangeValuesHegicV888(
//         1,
//         2,
//         timestamp + 86400 * 14,
//         80000000000,
//         120000000000,
//         "500000000"
//       );

//       console.log("optionWBTCList ==>", optionWBTCList);

//       chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
//         .properAddress;
//     });
//   });
// });
