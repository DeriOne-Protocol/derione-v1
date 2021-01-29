// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IOptionMarketCharmV02 {
    function SCALE() external view returns (uint256);

    function SCALE_SCALE() external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceCap() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function baseToken() external view returns (address);

    function buy(
        bool isLongToken,
        uint256 strikeIndex,
        uint256 optionsOut,
        uint256 maxAmountIn
    ) external returns (uint256 amountIn);

    function decimals() external view returns (uint8);

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool);

    function deposit(uint256 sharesOut, uint256 maxAmountIn)
        external
        returns (uint256 amountIn);

    function disputeExpiryPrice(uint256 _expiryPrice) external;

    function disputePeriod() external view returns (uint256);

    function expiryPrice() external view returns (uint256);

    function expiryTime() external view returns (uint256);

    function getCurrentCost() external view returns (uint256);

    function getCurrentPayoff() external view returns (uint256);

    function getTotalSupplies(address[] calldata optionTokens)
        external
        view
        returns (uint256[] memory totalSupplies);

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool);

    function initialize(
        address _baseToken,
        address _oracle,
        address[] calldata _longTokens,
        address[] calldata _shortTokens,
        uint256[] calldata _strikePrices,
        uint256 _expiryTime,
        bool _isPut,
        uint256 _tradingFee,
        uint256 _balanceCap,
        uint256 _disputePeriod,
        string calldata _symbol
    ) external;

    function isDisputePeriod() external view returns (bool);

    function isExpired() external view returns (bool);

    function isPaused() external view returns (bool);

    function isPut() external view returns (bool);

    function isSettled() external view returns (bool);

    function lastCost() external view returns (uint256);

    function lastPayoff() external view returns (uint256);

    function longTokens(uint256) external view returns (address);

    function name() external view returns (string memory);

    function numStrikes() external view returns (uint256);

    function oracle() external view returns (address);

    function owner() external view returns (address);

    function pause() external;

    function poolValue() external view returns (uint256);

    function renounceOwnership() external;

    function sell(
        bool isLongToken,
        uint256 strikeIndex,
        uint256 optionsIn,
        uint256 minAmountOut
    ) external returns (uint256 amountOut);

    function setBalanceCap(uint256 _balanceCap) external;

    function setDisputePeriod(uint256 _disputePeriod) external;

    function setExpiryTime(uint256 _expiryTime) external;

    function setOracle(address _oracle) external;

    function settle() external;

    function shortTokens(uint256) external view returns (address);

    function strikePrices(uint256) external view returns (uint256);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function tradingFee() external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferOwnership(address newOwner) external;

    function unpause() external;

    function withdraw(uint256 sharesIn, uint256 minAmountOut)
        external
        returns (uint256 amountOut);
}
