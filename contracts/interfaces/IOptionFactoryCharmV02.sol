// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOptionFactoryCharmV02 {
    function createMarket(
        address baseAsset,
        address quoteAsset,
        address oracle,
        uint256[] calldata strikePrices,
        uint256 expiryTime,
        bool isPut,
        uint256 tradingFee
    ) external returns (address marketAddress);

    function getMarketSymbol(
        string calldata underlying,
        uint256 expiryTime,
        bool isPut
    ) external pure returns (string memory);

    function getOptionSymbol(
        string calldata underlying,
        uint256 strikePrice,
        uint256 expiryTime,
        bool isPut,
        bool isLong
    ) external pure returns (string memory);

    function markets(uint256) external view returns (address);

    function numMarkets() external view returns (uint256);

    function optionMarketLibrary() external view returns (address);

    function optionTokenLibrary() external view returns (address);
}
