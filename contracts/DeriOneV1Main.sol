// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./DeriOneV1CharmV02.sol";
import "./DeriOneV1HegicV888.sol";
import "./libraries/DataTypes.sol";

/// @author tai
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


    function getOptionListFromExactValues(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) public view returns (DataTypes.Option[] memory) {
        require(
            (_expiryTimestamp > block.timestamp),
            "expiration date has to be some time in the future"
        );

        uint256 expirySecondsFromNow = _expiryTimestamp.sub(block.timestamp);

        DataTypes.Option memory optionHegicV888 =
            getOptionFromExactValuesHegicV888(
                _underlyingAsset,
                _optionType,
                expirySecondsFromNow,
                _strikeUSD,
                _size
            );
        require(
            hasEnoughLiquidityHegicV888(_underlyingAsset, _size) == true,
            "your size is too big for liquidity in the Hegic V888"
        );

        uint256 matchedOptionCountCharmV02 =
            getMatchedCountFromExactValues(
                _underlyingAsset,
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _size
            );

        DataTypes.Option memory optionCharmV02;
        if (matchedOptionCountCharmV02 > 0) {
            optionCharmV02 = getOptionFromExactValuesCharmV02(
                _underlyingAsset,
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _size
            );
        }
        // require(
        //     hasEnoughETHLiquidityCharmV02(_size) == true,
        //     "your size is too big for liquidity in the Charm V02"
        // );

        DataTypes.Option[] memory optionList;
        if (matchedOptionCountCharmV02 == 0) {
            optionList = new DataTypes.Option[](1);
            optionList[0] = optionHegicV888;
        } else {
            optionList = new DataTypes.Option[](2);
            optionList[0] = optionHegicV888;
            optionList[1] = optionCharmV02;
        }

        return optionList;
    }

    /// @dev expiration range is from now to expiry
    function getOptionListFromRangeValues(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) public view returns (DataTypes.Option[] memory) {
        uint256 expirySecondsFromNow = _expiryTimestamp.sub(block.timestamp);
        DataTypes.Option[] memory optionListHegicV888 =
            getOptionListFromRangeValuesHegicV888(
                _underlyingAsset,
                _optionType,
                expirySecondsFromNow,
                _minStrikeUSD,
                _maxStrikeUSD,
                _size
            );
        require(
            hasEnoughLiquidityHegicV888(_underlyingAsset, _size) == true,
            "your size is too big for liquidity in the Hegic V888"
        );

        DataTypes.Option[] memory optionListCharmV02 =
            getOptionListFromRangeValuesCharmV02(
                _underlyingAsset,
                _optionType,
                _expiryTimestamp,
                _minStrikeUSD,
                _maxStrikeUSD,
                _size
            );

        DataTypes.Option[] memory optionList =
            new DataTypes.Option[](
                optionListHegicV888.length + optionListCharmV02.length
            );

        for (uint256 i = 0; i < optionListHegicV888.length; i++) {
            optionList[i] = optionListHegicV888[i];
        }
        for (
            uint256 i = optionListHegicV888.length;
            i < optionList.length;
            i++
        ) {
            optionList[i] = optionListCharmV02[i - optionListHegicV888.length];
        }
        return optionList;
    }
}
