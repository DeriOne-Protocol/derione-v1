// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

library DataTypes {
    enum UnderlyingAsset {ETH, WBTC}
    enum OptionType {Call, Put}
    struct Option {
        DataTypes.UnderlyingAsset underlyingAsset;
        DataTypes.OptionType optionType;
        uint256 expiryTimestamp;
        uint256 strikeUSD;
        uint256 premiumWEI;
    }
}
