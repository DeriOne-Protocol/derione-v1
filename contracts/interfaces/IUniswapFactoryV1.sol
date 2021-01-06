// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IUniswapFactoryV1 {
    function initializeFactory(address template) external;

    function createExchange(address token) external returns (address out);

    function getExchange(address token) external returns (address out);

    function getToken(address exchange) external returns (address out);

    function getTokenWithId(uint256 token_id) external returns (address out);

    function exchangeTemplate() external returns (address out);

    function tokenCount() external returns (uint256 out);
}
