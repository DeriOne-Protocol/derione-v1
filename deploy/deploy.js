async function deploy() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // get the contract to deploy
  const DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");
  // const variables for the constructor
  const optionFactoryAddressCharmV02 =
    "0x443ec3dc7840c3eb610a2a80068dfe3c56822e86";
  const ETHOptionAddressHegicV888 =
    "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
  const WBTCOptionAddressHegicV888 =
    "0x3961245DB602eD7c03eECcda33eA3846bD8723BD";
  const ETHPoolAddressHegicV888 = "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";
  const WBTCPoolAddressHegicV888 = "0x20dd9e22d22dd0a6ef74a520cb08303b5fad5de7";
  const strikesRange = 100;
  // deploy the DeriOneV1Main contract with constructor arguments
  const deriOneV1Main = await DeriOneV1Main.deploy(
    optionFactoryAddressCharmV02,
    ETHOptionAddressHegicV888,
    WBTCOptionAddressHegicV888,
    ETHPoolAddressHegicV888,
    WBTCPoolAddressHegicV888,
    strikesRange
  );

  console.log("DeriOneV1Main deployed to:", deriOneV1Main.address);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
