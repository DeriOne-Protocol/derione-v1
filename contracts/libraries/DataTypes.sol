// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

library DataTypes {
    enum Protocol {Invalid, CharmV02, HegicV888, SirenV1}
    enum Asset {DAI, ETH, USDC, WBTC}
    enum OptionType {Invalid, Put, Call}

    struct Option {
        DataTypes.Protocol protocol;
        DataTypes.Asset underlyingAsset;
        DataTypes.Asset paymentAsset;
        DataTypes.OptionType optionType;
        uint256 expiryTimestamp;
        uint256 strikeUSD; // 8 decimals
        uint256 size; // WEI or WBTC. WEI has 18 decimals and WBTC has 8 decimals
        uint256 premium; // WEI or WBTC. WEI has 18 decimals and WBTC has 8 decimals
    }
}
