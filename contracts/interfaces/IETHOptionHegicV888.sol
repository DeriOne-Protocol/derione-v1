// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IETHOptionHegicV888 {
    enum OptionType {Invalid, Put, Call}

    function create(
        uint256 period,
        uint256 amount,
        uint256 strike,
        OptionType optionType
    ) external payable returns (uint256 optionID);

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
            uint256 settlementFee,
            uint256 strikeFee,
            uint256 periodFee
        );

    function impliedVolRate() external view returns (uint256);

    function migrate(uint256 count) external;

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

    function setOldHegicETHOptions(address oldAddr) external;

    function setOptionCollaterizationRatio(uint256 value) external;

    function setSettlementFeeRecipient(address recipient) external;

    function settlementFeeRecipient() external view returns (address);

    function stopMigrationProcess() external;

    function transfer(uint256 optionID, address newHolder) external;

    function transferOwnership(address newOwner) external;

    function transferPoolOwnership() external;

    function unlock(uint256 optionID) external;

    function unlockAll(uint256[] calldata optionIDs) external;
}
