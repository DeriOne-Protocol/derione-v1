// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IWBTCOptionHegicV888 {
    function approve() external;

    function create(
        uint256 period,
        uint256 amount,
        uint256 strike,
        uint8 optionType
    ) external returns (uint256 optionID);

    function ethToWbtcSwapPath(uint256) external view returns (address);

    function exercise(uint256 optionID) external;

    function fees(
        uint256 period,
        uint256 amount,
        uint256 strike,
        uint8 optionType
    )
        external
        view
        returns (
            uint256 total,
            uint256 totalETH,
            uint256 settlementFee,
            uint256 strikeFee,
            uint256 periodFee
        );

    function impliedVolRate() external view returns (uint256);

    function optionCollateralizationRatio() external view returns (uint256);

    function options(uint256)
        external
        view
        returns (
            uint8 state,
            address holder,
            uint256 strike,
            uint256 amount,
            uint256 lockedAmount,
            uint256 premium,
            uint256 expiration,
            uint8 optionType
        );

    function owner() external view returns (address);

    function pool() external view returns (address);

    function priceProvider() external view returns (address);

    function renounceOwnership() external;

    function setImpliedVolRate(uint256 value) external;

    function setOptionCollaterizationRatio(uint256 value) external;

    function setSettlementFeeRecipient(address recipient) external;

    function settlementFeeRecipient() external view returns (address);

    function transfer(uint256 optionID, address newHolder) external;

    function transferOwnership(address newOwner) external;

    function transferPoolOwnership() external;

    function uniswapRouter() external view returns (address);

    function unlock(uint256 optionID) external;

    function unlockAll(uint256[] calldata optionIDs) external;

    function wbtc() external view returns (address);
}
