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

    deriOneV1Main = await DeriOneV1Main.deploy(
      optionFactoryAddressCharmV02,
      ETHOptionAddressHegicV888,
      WBTCOptionAddressHegicV888,
      ETHPoolAddressHegicV888,
      WBTCPoolAddressHegicV888,
      strikesRange
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
  //       2,
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
  //       0,
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
