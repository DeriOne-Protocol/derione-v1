// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOpynOTokenV1 {
    function addERC20Collateral(address vaultOwner, uint256 amt)
        external
        returns (uint256);

    function getVaultOwners() external view returns (address[] memory);

    function name() external view returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool);

    function hasVault(address owner) external view returns (bool);

    function isExerciseWindow() external view returns (bool);

    function getVault(address vaultOwner)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            bool
        );

    function totalSupply() external view returns (uint256);

    function issueOTokens(uint256 oTokensToIssue, address receiver) external;

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function decimals() external view returns (uint8);

    function addAndSellERC20CollateralOption(
        uint256 amtToCreate,
        uint256 amtCollateral,
        address receiver
    ) external;

    function removeCollateral(uint256 amtToRemove) external;

    function liquidationFactor()
        external
        view
        returns (uint256 value, int32 exponent);

    function createAndSellETHCollateralOption(
        uint256 amtToCreate,
        address receiver
    ) external payable;

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function optionsExchange() external view returns (address);

    function createERC20CollateralOption(
        uint256 amtToCreate,
        uint256 amtCollateral,
        address receiver
    ) external;

    function exercise(
        uint256 oTokensToExercise,
        address[] memory vaultsToExerciseFrom
    ) external payable;

    function addERC20CollateralOption(
        uint256 amtToCreate,
        uint256 amtCollateral,
        address receiver
    ) external;

    function maxOTokensIssuable(uint256 collateralAmt)
        external
        view
        returns (uint256);

    function underlying() external view returns (address);

    function underlyingRequiredToExercise(uint256 oTokensToExercise)
        external
        view
        returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function renounceOwnership() external;

    function openVault() external returns (bool);

    function COMPOUND_ORACLE() external view returns (address);

    function liquidationIncentive()
        external
        view
        returns (uint256 value, int32 exponent);

    function owner() external view returns (address);

    function isOwner() external view returns (bool);

    function hasExpired() external view returns (bool);

    function symbol() external view returns (string memory);

    function addETHCollateral(address vaultOwner)
        external
        payable
        returns (uint256);

    function transactionFee()
        external
        view
        returns (uint256 value, int32 exponent);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function strike() external view returns (address);

    function underlyingExp() external view returns (int32);

    function collateralExp() external view returns (int32);

    function oTokenExchangeRate()
        external
        view
        returns (uint256 value, int32 exponent);

    function redeemVaultBalance() external;

    function setDetails(string memory _name, string memory _symbol) external;

    function addETHCollateralOption(uint256 amtToCreate, address receiver)
        external
        payable;

    function minCollateralizationRatio()
        external
        view
        returns (uint256 value, int32 exponent);

    function liquidate(address vaultOwner, uint256 oTokensToLiquidate) external;

    function strikePrice()
        external
        view
        returns (uint256 value, int32 exponent);

    function createAndSellERC20CollateralOption(
        uint256 amtToCreate,
        uint256 amtCollateral,
        address receiver
    ) external;

    function isUnsafe(address vaultOwner) external view returns (bool);

    function addAndSellETHCollateralOption(
        uint256 amtToCreate,
        address receiver
    ) external payable;

    function collateral() external view returns (address);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function maxOTokensLiquidatable(address vaultOwner)
        external
        view
        returns (uint256);

    function expiry() external view returns (uint256);

    function transferFee(address _address) external;

    function burnOTokens(uint256 amtToBurn) external;

    function createETHCollateralOption(uint256 amtToCreate, address receiver)
        external
        payable;

    function updateParameters(
        uint256 _liquidationIncentive,
        uint256 _liquidationFactor,
        uint256 _transactionFee,
        uint256 _minCollateralizationRatio
    ) external;

    function transferOwnership(address newOwner) external;

    function isETH(address _ierc20) external pure returns (bool);

    function removeUnderlying() external;
}
