pragma solidity ^0.6.0;

interface IMarketSirenV1 {
    function bToken() external view returns (address);

    function calculateFee(uint256 amount, uint16 basisPoints)
        external
        pure
        returns (uint256);

    function calculatePaymentAmount(uint256 collateralAmount)
        external
        view
        returns (uint256);

    function claimCollateral(uint256 collateralAmount) external;

    function claimFeeBasisPoints() external view returns (uint16);

    function closeFeeBasisPoints() external view returns (uint16);

    function closePosition(uint256 collateralAmount) external;

    function collateralToken() external view returns (address);

    function exerciseFeeBasisPoints() external view returns (uint16);

    function exerciseOption(uint256 collateralAmount) external;

    function expirationDate() external view returns (uint256);

    function getLogicAddress() external view returns (address logicAddress);

    function initialize(
        string calldata _marketName,
        address _collateralToken,
        address _paymentToken,
        uint8 _marketStyle,
        uint256 _priceRatio,
        uint256 _expirationDate,
        uint16 _exerciseFeeBasisPoints,
        uint16 _closeFeeBasisPoints,
        uint16 _claimFeeBasisPoints,
        address _tokenImplementation
    ) external;

    function marketName() external view returns (string memory);

    function marketStyle() external view returns (uint8);

    function mintOptions(uint256 collateralAmount) external;

    function owner() external view returns (address);

    function paymentToken() external view returns (address);

    function priceRatio() external view returns (uint256);

    function proxiableUUID() external pure returns (bytes32);

    function recoverTokens(address token) external;

    function renounceOwnership() external;

    function restrictedMinter() external view returns (address);

    function selfDestructMarket(address refundAddress) external;

    function state() external view returns (uint8);

    function transferOwnership(address newOwner) external;

    function updateImplementation(address newImplementation) external;

    function updateRestrictedMinter(address _restrictedMinter) external;

    function wToken() external view returns (address);
}
