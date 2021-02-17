// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./DeriOneV1CharmV02.sol";
import "./DeriOneV1HegicV888.sol";
import "./libraries/DataTypes.sol";

/// @author tai
/// @notice For now, this contract gets the cheapest ETH/WETH put options price from Opyn V1 and Hegic V888
/// @dev explicitly state the data location for all variables of struct, array or mapping types (including function parameters)
/// @dev adjust visibility of variables. they should be all private by default i guess
contract DeriOneV1Main is DeriOneV1CharmV02, DeriOneV1HegicV888 {
    using SafeMath for uint256;

    constructor(
        address _charmV02OptionFactoryAddress,
        address _hegicETHOptionV888Address,
        address _hegicV888ETHPoolAddress
    )
        public
        DeriOneV1CharmV02(_charmV02OptionFactoryAddress)
        DeriOneV1HegicV888(_hegicETHOptionV888Address, _hegicV888ETHPoolAddress)
    {}

    /// @notice get the cheapest ETH put option across protocols
    /// @param _expiryInTimestamp expiration date in unix timestamp
    /// @param _strikeUSD strike price in USD with 8 decimals
    /// @param _optionType option type
    /// @param _sizeWEI option size in WEI
    function getETHOptionListWithFixedValues(
        uint256 _expiryInTimestamp,
        uint256 _strikeUSD,
        DataTypes.OptionType _optionType,
        uint256 _sizeWEI
    ) public view returns (Option memory) {
        require((_expiryTimestamp > block.timestamp), "expiration date has to be some time in the future");

        uint256 expiryInSeconds = _expiryInTimestamp.sub(block.timestamp);

        DataTypes.Option memory ETHOptionHegicV888 =
            getETHOptionHegicV888(expiryInSeconds, _strikeUSD, _optionType, _sizeWEI);
        require(
            hasEnoughETHLiquidityHegicV888(_sizeWEI) == true,
            "your size is too big for liquidity in the Hegic V888"
        );
        // the cheapest ETH put option across options protocols
        Option memory cheapestETHOption =
            Option(
                Protocol.HegicV888,
                DataTypes.UnderlyingAsset.ETH,
                _optionType,
                ETHOptionHegicV888.expiryTimestamp,
                ETHOptionHegicV888.strikeUSD,
                _sizeWEI,
                ETHPutHegicV888.premiumWEI
        return cheapestETHOption;
            );
        return cheapestETHOption;
    }
}
