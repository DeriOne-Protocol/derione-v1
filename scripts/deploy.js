async function deploy() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // get the contract to deploy
  const DeriOneV1Main = await ethers.getContractFactory("DeriOneV1Main");
  // const variables for the constructor
  const hegicETHOptionV888Address =
    "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2";
  const hegicETHPoolV888Address = "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b";
  // deploy the DeriOneV1Main contract with constructor arguments
  const deriOneV1Main = await DeriOneV1Main.deploy(
    hegicETHOptionV888Address,
    hegicETHPoolV888Address
  );

  console.log("DeriOneV1Main deployed to:", deriOneV1Main.address);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
