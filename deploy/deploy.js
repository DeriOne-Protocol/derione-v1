async function deploy() {

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
