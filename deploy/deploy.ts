import { ethers } from "hardhat";
import { CONSTRUCTOR_VALUES } from "../constants/constants";

async function deploy() {
  const DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");

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
  const deriOneV1Main = await DeriOneV1Main.deploy(
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

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
