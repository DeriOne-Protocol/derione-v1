// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOptionFactoryCharmV02 {
    function createMarket(
        address _baseToken,
        address _quoteToken,
        address _oracle,
        uint256[] calldata _strikePrices,
        uint256 _expiryTime,
        bool _isPut,
        uint256 _tradingFee,
        uint256 _balanceCap,
        uint256 _disputePeriod
    ) external returns (address);

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

    function optionTokenLibary() external view returns (address);
}
