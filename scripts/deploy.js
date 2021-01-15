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
  const opynExchangeV1Address = "0x39246c4f3f6592c974ebc44f80ba6dc69b817c71";
  const opynOptionsFactoryV1Address =
    "0xcc5d905b9c2c8c9329eb4e25dc086369d6c7777c";
  const uniswapFactoryV1Address = "0xc0a47dfe034b400b47bdad5fecda2621de6c4d95";
  // deploy the DeriOneV1Main contract with constructor arguments
  const deriOneV1Main = await DeriOneV1Main.deploy(
    hegicETHOptionV888Address,
    hegicETHPoolV888Address,
    opynExchangeV1Address,
    opynOptionsFactoryV1Address,
    uniswapFactoryV1Address
  );

  console.log("DeriOneV1Main deployed to:", deriOneV1Main.address);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
