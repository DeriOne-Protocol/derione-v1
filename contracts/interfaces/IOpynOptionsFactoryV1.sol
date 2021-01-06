// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOpynOptionsFactoryV1 {
    function tokens(string calldata) external view returns (address);

    function changeAsset(string calldata _asset, address _addr) external;

    function optionsExchange() external view returns (address);

    function renounceOwnership() external;

    function getNumberOfOptionsContracts() external view returns (uint256);

    function owner() external view returns (address);

    function isOwner() external view returns (bool);

    function createOptionsContract(
        string calldata _collateralType,
        int32 _collateralExp,
        string calldata _underlyingType,
        int32 _underlyingExp,
        int32 _oTokenExchangeExp,
        uint256 _strikePrice,
        int32 _strikeExp,
        string calldata _strikeAsset,
        uint256 _expiry,
        uint256 _windowSize
    ) external returns (address);

    function oracleAddress() external view returns (address);

    function addAsset(string calldata _asset, address _addr) external;

    function supportsAsset(string calldata _asset) external view returns (bool);

    function deleteAsset(string calldata _asset) external;

    function optionsContracts(uint256) external view returns (address);

    function transferOwnership(address newOwner) external;
}
