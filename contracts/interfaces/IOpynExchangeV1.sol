// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOpynExchangeV1 {
    function premiumReceived(
        address oTokenAddress,
        address payoutTokenAddress,
        uint256 oTokensToSell
    ) external view returns (uint256);

    function sellOTokens(
        address receiver,
        address oTokenAddress,
        address payoutTokenAddress,
        uint256 oTokensToSell
    ) external;

    function buyOTokens(
        address receiver,
        address oTokenAddress,
        address paymentTokenAddress,
        uint256 oTokensToBuy
    ) external payable;

    function premiumToPay(
        address oTokenAddress,
        address paymentTokenAddress,
        uint256 oTokensToBuy
    ) external view returns (uint256);

    function UNISWAP_FACTORY() external view returns (address);

    function uniswapBuyOToken(
        address paymentToken,
        address oToken,
        uint256 _amt,
        address _transferTo
    ) external returns (uint256);
}
