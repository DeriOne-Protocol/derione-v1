// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IMinterAmmSirenV1 {
    function MINIMUM_TRADE_SIZE() external view returns (uint256);

    function assetPair() external view returns (bytes32);

    function bTokenBuy(
        uint256 marketIndex,
        uint256 bTokenAmount,
        uint256 collateralMaximum
    ) external returns (uint256);

    function bTokenGetCollateralIn(address market, uint256 bTokenAmount)
        external
        view
        returns (uint256);

    function bTokenGetCollateralOut(address market, uint256 bTokenAmount)
        external
        view
        returns (uint256);

    function bTokenSell(
        uint256 marketIndex,
        uint256 bTokenAmount,
        uint256 collateralMinimum
    ) external returns (uint256);

    function calcPrice(
        uint256 timeUntilExpiry,
        uint256 strike,
        uint256 currentPrice,
        uint256 volatility
    ) external pure returns (uint256);

    function claimAllExpiredTokens() external;

    function claimExpiredTokens(address optionMarket, uint256 wTokenBalance)
        external;

    function collateralDepositLimits(address)
        external
        view
        returns (bool allowedToDeposit, uint256 currentDeposit);

    function collateralToken() external view returns (address);

    function enforceDepositLimits() external view returns (bool);

    function getCurrentCollateralPrice() external view returns (uint256);

    function getLogicAddress() external view returns (address logicAddress);

    function getMarket(uint256 marketIndex) external view returns (address);

    function getMarkets() external view returns (address[] memory);

    function getPriceForMarket(address market) external view returns (uint256);

    function getTokensSaleValue(uint256 lpTokenAmount)
        external
        view
        returns (uint256);

    function getTotalPoolValue(bool includeUnclaimed)
        external
        view
        returns (uint256);

    function getUnclaimedBalances() external view returns (uint256, uint256);

    function getVirtualReserves(address market)
        external
        view
        returns (uint256, uint256);

    function globalDepositLimit() external view returns (uint256);

    function initialize(
        address _registry,
        address _priceOracle,
        address _paymentToken,
        address _collateralToken,
        address _tokenImplementation,
        uint16 _tradeFeeBasisPoints,
        bool _shouldInvertOraclePrice
    ) external;

    function lpToken() external view returns (address);

    function owner() external view returns (address);

    function paymentToken() external view returns (address);

    function provideCapital(uint256 collateralAmount, uint256 lpTokenMinimum)
        external;

    function proxiableUUID() external pure returns (bytes32);

    function registry() external view returns (address);

    function renounceOwnership() external;

    function setCapitalDepositLimit(
        address[] calldata lpAddresses,
        bool[] calldata allowedToDeposit
    ) external;

    function setEnforceDepositLimits(
        bool _enforceDepositLimits,
        uint256 _globalDepositLimit
    ) external;

    function setVolatilityFactor(uint256 _volatilityFactor) external;

    function tradeFeeBasisPoints() external view returns (uint16);

    function transferOwnership(address newOwner) external;

    function updateAmmImplementation(address newAmmImplementation) external;

    function volatilityFactor() external view returns (uint256);

    function withdrawCapital(
        uint256 lpTokenAmount,
        bool sellTokens,
        uint256 collateralMinimum
    ) external;
}
