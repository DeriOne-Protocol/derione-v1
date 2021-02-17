// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

library DataTypes {
    enum Protocol {Invalid, CharmV02, HegicV888}
    enum UnderlyingAsset {ETH, WBTC}
    enum OptionType {Invalid, Put, Call}

    struct Option {
        DataTypes.Protocol protocol;
        DataTypes.UnderlyingAsset underlyingAsset;
        DataTypes.OptionType optionType;
        uint256 expiryTimestamp;
        uint256 strikeUSD;
        uint256 sizeWEI;
        uint256 premiumWEI;
    }
}
