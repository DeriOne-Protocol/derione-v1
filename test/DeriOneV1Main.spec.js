const { solidity } = require("ethereum-waffle");
const { ethers, waffle } = require("hardhat");
const provider = waffle.provider;
const chai = require("chai");
chai.use(solidity);

// async function main() {
// console.log("test");
// console.log('provider ==>', provider);
// try {
//   let block = await provider.getBlock();
//   console.log("block ==>", block);
// } catch (err) {
//   console.log(err);
// }
// console.log("await provider.getBlockNumber() ==>", await provider.getBlockNumber());
// console.log("await provider.getBalance(0xa7D41F49dAdCA972958487391d4461a5d0E1c3e9) ==>", await provider.getBalance(0xa7D41F49dAdCA972958487391d4461a5d0E1c3e9));
// const block = await provider.getBlock();
// console.log("block ==>", block);
// block is not logged
// }

// (async () => {
//   await main();
// })();

describe("DeriOneV1Main", async function () {
  let DeriOneV1Main;
  let deriOneV1Main;

  let block;
  try {
    block = await provider.getBlock();
  } catch (err) {
    alert(err);
  }

  const timestamp = block.timestamp;

  before(async function () {
    DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

    // const variables for the constructor
    const optionFactoryAddressCharmV02 =
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

    // get all the amm addresses of siren
    let ammAddressListSirenV1 = [
      "0x25bc339170adbff2b7b9ede682072577fa9d96e8",
      "0x679c5b95b41a027a24584fd81b856571a10b3649",
      "0x8337706f5faab1941c8b8b849d21b5016987a04a",
      "0x87a3ef113c210ab35afebe820ff9880bf0dd4bfc",
      "0xc9eb7567ca3c72962c99c0b7dff0beeca1736d3b",
      "0xde76305e3379aa5391ffc6028ceec655686c5b0a",
      "0xe49419d13cc7eae4d35c81539d9beb9dd78197c3",
      "0xfb6b766172b6db624ed6cbefb4ad5380455b6586"
    ];

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
      strikesRange
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

  // // CALLS
  // describe("getBestETHOptionFromExactValues", function () {
  //   it("should get the best ETH option from exact values", async function () {
  //     const ETHOptionList = await deriOneV1Main.getBestETHOptionFromExactValues(
  //       2,
  //       timestamp + 86400 * 14,
  //       90000000000, // USD price decimals are 8 in hegic
  //       "5000000000000000000"
  //     );
  //     console.log(
  //       "ETHOptionList from getBestETHOptionFromExactValues ==>",
  //       ETHOptionList
  //     );

  //     chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
  //       .properAddress;
  //   });
  // });

  // describe("getBestETHOptionFromRangeValues", function () {
  //   it("should get the best ETH option from range values", async function () {
  //     const ETHOptionList = await deriOneV1Main.getBestETHOptionFromRangeValues(
  //       2,
  //       timestamp + 86400 * 14,
  //       70000000000, // USD price decimals are 8 in hegic
  //       140000000000, // USD price decimals are 8 in hegic
  //       "5000000000000000000"
  //     );
  //     console.log(
  //       "ETHOptionList from getBestETHOptionFromRangeValues ==>",
  //       ETHOptionList
  //     );

  //     chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
  //       .properAddress;
  //   });
  // });

  // describe("getOptionListFromExactValues", function () {
  //   it("should get ETH options list from exact values", async function () {
  //     const ETHOptionList = await deriOneV1Main.getOptionListFromExactValues(
  //       3,
  //       timestamp + 86400 * 14,
  //       90000000000, // USD price decimals are 8 in hegic
  //       "5000000000000000000"
  //     );
  //     console.log(
  //       "ETHOptionList from getOptionListFromExactValues ==>",
  //       ETHOptionList
  //     );

  //     chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
  //       .properAddress;
  //   });
  // });

  // describe("getOptionListFromRangeValues", function () {
  //   it("should get ETH options list from range values", async function () {
  //     const ETHOptionList = await deriOneV1Main.getOptionListFromRangeValues(
  //       1,
  //       2,
  //       timestamp + 86400 * 14,
  //       70000000000, // USD price decimals are 8 in hegic
  //       140000000000, // USD price decimals are 8 in hegic
  //       "5000000000000000000"
  //     );
  //     console.log(
  //       "ETHOptionList from getOptionListFromRangeValues ==>",
  //       ETHOptionList
  //     );

  //     chai.expect("0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419").to.be
  //       .properAddress;
  //   });
  // });

  // // TRANSACTIONS;
  // describe("Buy the best option", function () {});
});
