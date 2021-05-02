import { ethers } from "hardhat";
import { CONSTRUCTOR_VALUES } from "../constants/constants";

let DeriOneV1Main;
let deriOneV1Main;

async function deploy() {
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

  // deploy the DeriOneV1Main contract with constructor arguments
  deriOneV1Main = await DeriOneV1Main.deploy(
    optionFactoryAddressCharmV02,
    ETHOptionAddressHegicV888,
    WBTCOptionAddressHegicV888,
    ETHPoolAddressHegicV888,
    WBTCPoolAddressHegicV888,
    strikesRange,
    ammAddressListSirenV1
  );

  console.log("DeriOneV1Main deployed to:", deriOneV1Main.address);
}

(async () => {
  try {
    await deploy();
  } catch (error) {
    console.error(error);
  }
})();
