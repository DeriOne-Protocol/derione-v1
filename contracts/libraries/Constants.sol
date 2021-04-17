pragma solidity ^0.6.0;

library Constants {
    address public constant SUSHI_TokenAddress =
        0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
    address public constant UNI_TokenAddress =
        0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
    address public constant USDC_TokenAddress =
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant WBTC_TOKEN =
        0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address public constant WETH_TokenAddress =
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant YFI_TokenAddress =
        0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e;

    function getSUSHITokenAddress() internal pure returns (address) {
        return SUSHI_TokenAddress;
    }

    function getUNITokenAddress() internal pure returns (address) {
        return UNI_TokenAddress;
    }

    function getUSDCTokenAddress() internal pure returns (address) {
        return USDC_TokenAddress;
    }

    function getWBTCTokenAddress() internal pure returns (address) {
        return WBTC_TOKEN;
    }

    function getWETHTokenAddress() internal pure returns (address) {
        return WETH_TokenAddress;
    }

    function getYFITokenAddress() internal pure returns (address) {
        return YFI_TokenAddress;
    }
}
