import { BigNumber } from "@ethersproject/bignumber";

export const CONSTRUCTOR_VALUES = {
  optionFactoryAddressCharmV02: "0xCDFE169dF3D64E2e43D88794A21048A52C742F2B",
  // make it possible to updated this address with a transaction
  ETHOptionAddressHegicV888: "0xEfC0eEAdC1132A12c9487d800112693bf49EcfA2",
  WBTCOptionAddressHegicV888: "0x3961245DB602eD7c03eECcda33eA3846bD8723BD",
  ETHPoolAddressHegicV888: "0x878f15ffc8b894a1ba7647c7176e4c01f74e140b",
  WBTCPoolAddressHegicV888: "0x20dd9e22d22dd0a6ef74a520cb08303b5fad5de7",
  strikesRange: 100,
  ammAddressListSirenV1: [
    "0x25bc339170adbff2b7b9ede682072577fa9d96e8",
    "0x679c5b95b41a027a24584fd81b856571a10b3649",
    "0x8337706f5faab1941c8b8b849d21b5016987a04a",
    "0x87a3ef113c210ab35afebe820ff9880bf0dd4bfc",
    "0xc9eb7567ca3c72962c99c0b7dff0beeca1736d3b",
    "0xde76305e3379aa5391ffc6028ceec655686c5b0a",
    "0xe49419d13cc7eae4d35c81539d9beb9dd78197c3",
    "0xfb6b766172b6db624ed6cbefb4ad5380455b6586"
  ]
};

export const ASSET_NAMES = {
  Invalid: BigNumber.from(0),
  DAI: BigNumber.from(1),
  ETH: BigNumber.from(2),
  SUSHI: BigNumber.from(3),
  UNI: BigNumber.from(4),
  USDC: BigNumber.from(5),
  WBTC: BigNumber.from(6),
  WETH: BigNumber.from(7),
  YFI: BigNumber.from(8)
};

export const OPTION_SIZE = {
  1: BigNumber.from(1).mul(BigNumber.from(10).pow(18)),
  5: BigNumber.from(5).mul(BigNumber.from(10).pow(18))
};

export const OPTION_TYPE_NAMES = {
  Invalid: BigNumber.from(0),
  Put: BigNumber.from(1),
  Call: BigNumber.from(2)
};

export const STRIKE_PRICE = {
  0: BigNumber.from(0).mul(BigNumber.from(10).pow(8)),
  50: BigNumber.from(50).mul(BigNumber.from(10).pow(8)),
  400: BigNumber.from(400).mul(BigNumber.from(10).pow(8)),
  3000: BigNumber.from(3000).mul(BigNumber.from(10).pow(8)),
  5000: BigNumber.from(5000).mul(BigNumber.from(10).pow(8))
};

const timestamp = Date.now();
export const TIMESTAMP = {
  oneMonth: BigNumber.from(timestamp).add(BigNumber.from(86400).mul(30)),
  fourMonth: BigNumber.from(timestamp).add(BigNumber.from(86400).mul(120))
};
