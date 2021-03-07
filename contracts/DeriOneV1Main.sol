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
        address _ETHOptionAddressHegicV888,
        address _WBTCOptionAddressHegicV888,
        address _ETHPoolAddressHegicV888,
        address _WBTCPoolAddressHegicV888,
        uint256 _strikesRange
    )
        public
        DeriOneV1CharmV02(_charmV02OptionFactoryAddress)
        DeriOneV1HegicV888(
            _ETHOptionAddressHegicV888,
            _WBTCOptionAddressHegicV888,
            _ETHPoolAddressHegicV888,
            _WBTCPoolAddressHegicV888,
            _strikesRange
        )
    {}


    /// @param _expiryTimestamp expiration date in unix timestamp
    /// @param _strikeUSD strike price in USD with 8 decimals
    /// @param _optionType option type
    /// @param _sizeWEI option size in WEI
    function getETHOptionListFromExactValues(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _sizeWEI
    ) public view returns (DataTypes.Option[] memory) {
        require(
            (_expiryTimestamp > block.timestamp),
            "expiration date has to be some time in the future"
        );

        uint256 expirySecondsFromNow = _expiryTimestamp.sub(block.timestamp);

        DataTypes.Option memory ETHOptionHegicV888 =
            getOptionFromExactValuesHegicV888(
                DataTypes.UnderlyingAsset.ETH,
                _optionType,
                expirySecondsFromNow,
                _strikeUSD,
                _sizeWEI
            );
        require(
            hasEnoughLiquidityHegicV888(
                DataTypes.UnderlyingAsset.ETH,
                _sizeWEI
            ) == true,
            "your size is too big for liquidity in the Hegic V888"
        );

        uint256 matchedOptionCountCharmV02 =
            getMatchedCountFromExactValues(
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _sizeWEI
            );

        DataTypes.Option memory ETHOptionCharmV02;
        if (matchedOptionCountCharmV02 > 0) {
            ETHOptionCharmV02 = getETHOptionFromExactValuesCharmV02(
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _sizeWEI
            );
        }
        require(
            hasEnoughETHLiquidityCharmV02(_sizeWEI) == true,
            "your size is too big for liquidity in the Charm V02"
        );

        DataTypes.Option[] memory ETHOptionList;
        if (matchedOptionCountCharmV02 == 0) {
            ETHOptionList = new DataTypes.Option[](1);
            ETHOptionList[0] = ETHOptionHegicV888;
        } else {
            ETHOptionList = new DataTypes.Option[](2);
            ETHOptionList[0] = ETHOptionHegicV888;
            ETHOptionList[1] = ETHOptionCharmV02;
        }

        return ETHOptionList;
    }

    /// @param _underlyingAsset underlying asset
    /// @param _optionType option type
    /// @param _expiryTimestamp maximum expiration date in seconds from now
    /// @param _minStrikeUSD minimum strike price in USD with 8 decimals
    /// @param _maxStrikeUSD maximum strike price in USD with 8 decimals
    /// @param _sizeWEI option size in WEI
    /// @dev expiration range is from now to expiry
    function getETHOptionListFromRangeValues(
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) public view returns (DataTypes.Option[] memory) {
        uint256 expirySecondsFromNow = _expiryTimestamp.sub(block.timestamp);
        DataTypes.Option[] memory ETHHegicV888OptionList =
            getOptionListFromRangeValuesHegicV888(
                _underlyingAsset,
                _optionType,
                expirySecondsFromNow,
                _minStrikeUSD,
                _maxStrikeUSD,
                _sizeWEI
            );
        require(
            hasEnoughLiquidityHegicV888(
                DataTypes.UnderlyingAsset.ETH,
                _sizeWEI
            ) == true,
            "your size is too big for liquidity in the Hegic V888"
        );

        DataTypes.Option[] memory ETHCharmV02OptionList =
            getETHOptionListFromRangeValuesCharmV02(
                _optionType,
                _expiryTimestamp,
                _minStrikeUSD,
                _maxStrikeUSD,
                _sizeWEI
            );

        DataTypes.Option[] memory ETHOptionList =
            new DataTypes.Option[](
                ETHHegicV888OptionList.length + ETHCharmV02OptionList.length
            );

        for (uint256 i = 0; i < ETHHegicV888OptionList.length; i++) {
            ETHOptionList[i] = ETHHegicV888OptionList[i];
        }
        for (
            uint256 i = ETHHegicV888OptionList.length;
            i < ETHOptionList.length;
            i++
        ) {
            ETHOptionList[i] = ETHCharmV02OptionList[
                i - ETHHegicV888OptionList.length
            ];
        }
        return ETHOptionList;
    }
}
