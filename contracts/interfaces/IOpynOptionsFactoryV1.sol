// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOpynOptionsFactoryV1 {
    function tokens(string memory) external view returns (address);

    function changeAsset(string memory _asset, address _addr) external;

    function optionsExchange() external view returns (address);

    function renounceOwnership() external;

    function getNumberOfOptionsContracts() external view returns (uint256);

    function owner() external view returns (address);

    function isOwner() external view returns (bool);

    function createOptionsContract(
        string memory _collateralType,
        int32 _collateralExp,
        string memory _underlyingType,
        int32 _underlyingExp,
        int32 _oTokenExchangeExp,
        uint256 _strikePrice,
        int32 _strikeExp,
        string memory _strikeAsset,
        uint256 _expiry,
        uint256 _windowSize
    ) external returns (address);

    function oracleAddress() external view returns (address);

    function addAsset(string memory _asset, address _addr) external;

    function supportsAsset(string memory _asset) external view returns (bool);

    function deleteAsset(string memory _asset) external;

    function optionsContracts() external view returns (address[] calldata);

    function transferOwnership(address newOwner) external;
}
