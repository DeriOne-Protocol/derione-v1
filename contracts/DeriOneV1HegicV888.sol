// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IETHOptionHegicV888.sol";
import "./interfaces/IETHPoolHegicV888.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1HegicV888 is Ownable {
    using SafeMath for uint256;

    IETHOptionHegicV888 private ETHOptionHegicV888;
    IETHPoolHegicV888 private ETHPoolHegicV888;

    uint256[] public expiriesStandard = [
        1 days,
        1 weeks,
        2 weeks,
        3 weeks,
        4 weeks
    ];
    uint256[] public strikesStandard;

    constructor(
        address _hegicETHOptionV888Address,
        address _hegicV888ETHPoolAddress,
        uint256 _strikesRange
    ) public {
        instantiateETHOptionHegicV888(_hegicETHOptionV888Address);
        instantiateETHPoolHegicV888(_hegicV888ETHPoolAddress);
        updateStrikesStandard(_strikesRange);
    }

    /// @param _hegicETHOptionV888Address HegicETHOptionV888Address
    function instantiateETHOptionHegicV888(address _hegicETHOptionV888Address)
        public
        onlyOwner
    {
        ETHOptionHegicV888 = IETHOptionHegicV888(_hegicETHOptionV888Address);
    }

    /// @param _hegicV888ETHPoolAddress HegicETHPoolV888Address
    function instantiateETHPoolHegicV888(address _hegicV888ETHPoolAddress)
        public
        onlyOwner
    {
        ETHPoolHegicV888 = IETHPoolHegicV888(_hegicV888ETHPoolAddress);
    }

    function updateStrikesStandard(uint256 _strikesRange) public onlyOwner {
        delete strikesStandard;
        for (uint256 i = 0; i < _strikesRange; i++) {
            strikesStandard.push(i.mul(25).mul(10**8));
        }
    }

    /// @param _sizeWEI the size of an option to buy in WEI
    function hasEnoughETHLiquidityHegicV888(uint256 _sizeWEI)
        internal
        view
        returns (bool)
    {
        // `(Total ETH in contract) * 0.8 - the amount utilized for options`
        // we might or might not need the *0.8 part
        uint256 availableBalance =
            ETHPoolHegicV888.totalBalance().mul(8).div(10);
        uint256 amountUtilized =
            ETHPoolHegicV888.totalBalance().sub(
                ETHPoolHegicV888.availableBalance()
            );

        require(
            availableBalance > amountUtilized,
            "there is not enough available balance"
        );
        uint256 maxSize = availableBalance.sub(amountUtilized);

        // what happens when the value of a uint256 is negative?
        // is this equation right?
        if (maxSize > _sizeWEI) {
            return true;
        } else if (maxSize <= _sizeWEI) {
            return false;
        }
    }

    /// @notice return the ETH option in Hegic v888
    /// @param _optionType option type
    /// @param _expirySecondsFromNow expiration date in seconds from now
    /// @param _strikeUSD strike price in USD with 8 decimals
    /// @param _sizeWEI option size in WEI
    function getETHOptionFromExactValuesHegicV888(
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _strikeUSD,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option memory) {
        (uint256 minimumPremiumToPayWEI, , , ) =
            ETHOptionHegicV888.fees(
                _expirySecondsFromNow,
                _sizeWEI,
                _strikeUSD,
                uint8(_optionType)
            );

        uint256 expiryTimestamp = block.timestamp + _expirySecondsFromNow;

        DataTypes.Option memory ETHOption =
            DataTypes.Option(
                DataTypes.Protocol.HegicV888,
                DataTypes.UnderlyingAsset.ETH,
                _optionType,
                expiryTimestamp,
                _strikeUSD,
                _sizeWEI,
                minimumPremiumToPayWEI
            );
        return ETHOption;
    }

    function _constructOptionStandardList()
        private
        view
        returns (DataTypes.Option[] memory)
    {
        DataTypes.Option[] memory optionStandardList =
            new DataTypes.Option[](
                expiriesStandard.length.mul(strikesStandard.length)
            );

        for (
            uint256 expiryCount = 0;
            expiryCount < expiriesStandard.length;
            expiryCount++
        ) {
            for (
                uint256 strikeCount = 0;
                strikeCount < strikesStandard.length;
                strikeCount++
            ) {
                uint256 optionCounter;
                if (expiryCount == 0) {
                    optionCounter = strikeCount;
                } else if (expiryCount > 0) {
                    optionCounter =
                        strikeCount +
                        expiryCount.mul(strikesStandard.length);
                }

                optionStandardList[optionCounter] = DataTypes.Option(
                    DataTypes.Protocol.HegicV888,
                    DataTypes.UnderlyingAsset.ETH,
                    DataTypes.OptionType.Invalid,
                    expiriesStandard[expiryCount],
                    strikesStandard[strikeCount],
                    0,
                    0
                );
            }
        }
        return optionStandardList;
    }

    function _getMatchedOptionList(
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI,
        DataTypes.Option[] memory _optionStandardList
    ) private view returns (DataTypes.Option[] memory) {
        uint256 expiryTimestamp = block.timestamp + _expirySecondsFromNow;

        uint256 matchedOptionCount;
        for (uint256 i = 0; i < _optionStandardList.length; i++) {
            if (
                block.timestamp < _optionStandardList[i].expiryTimestamp &&
                _optionStandardList[i].expiryTimestamp < expiryTimestamp &&
                _minStrikeUSD < _optionStandardList[i].strikeUSD &&
                _optionStandardList[i].strikeUSD < _maxStrikeUSD
            ) {
                matchedOptionCount = matchedOptionCount.add(1);
            }
        }

        DataTypes.Option[] memory matchedOptionList =
            new DataTypes.Option[](matchedOptionCount);

        for (uint256 i = 0; i < _optionStandardList.length; i++) {
            if (
                block.timestamp < _optionStandardList[i].expiryTimestamp &&
                _optionStandardList[i].expiryTimestamp < expiryTimestamp &&
                _minStrikeUSD < _optionStandardList[i].strikeUSD &&
                _optionStandardList[i].strikeUSD < _maxStrikeUSD
            ) {
                uint256 matchedCount = 0;
                matchedOptionList[matchedCount] = DataTypes.Option(
                    DataTypes.Protocol.HegicV888,
                    DataTypes.UnderlyingAsset.ETH,
                    _optionType,
                    _optionStandardList[i].expiryTimestamp,
                    _optionStandardList[i].strikeUSD,
                    _sizeWEI,
                    0
                );
                matchedCount.add(1);
            }
        }
        return matchedOptionList;
    }

    /// @param _optionType option type
    /// @param _expirySecondsFromNow maximum expiration date in seconds from now
    /// @param _minStrikeUSD minimum strike price in USD with 8 decimals
    /// @param _maxStrikeUSD maximum strike price in USD with 8 decimals
    /// @param _sizeWEI option size in WEI
    function getETHOptionListFromRangeValuesHegicV888(
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionStandardList =
            _constructOptionStandardList();
        DataTypes.Option[] memory matchedOptionList =
            _getMatchedOptionList(
                _optionType,
                _expirySecondsFromNow,
                _minStrikeUSD,
                _maxStrikeUSD,
                _sizeWEI,
                optionStandardList
            );

        for (uint256 i = 0; i < matchedOptionList.length; i++) {
            uint256 expirySecondsFromNow =
                matchedOptionList[i].expiryTimestamp.sub(block.timestamp);

            (uint256 minimumPremiumToPayWEI, , , ) =
                ETHOptionHegicV888.fees(
                    expirySecondsFromNow,
                    _sizeWEI,
                    matchedOptionList[i].strikeUSD,
                    uint8(_optionType)
                );

            matchedOptionList[i] = DataTypes.Option(
                DataTypes.Protocol.HegicV888,
                DataTypes.UnderlyingAsset.ETH,
                _optionType,
                matchedOptionList[i].expiryTimestamp,
                matchedOptionList[i].strikeUSD,
                _sizeWEI,
                minimumPremiumToPayWEI
            );
        }

        return matchedOptionList;
    }
}

// you need to use require for strike price and expiry and possibly in other places
// the hegic has some require
// https://github.com/hegic/contracts-v888/blob/ecdc7816c1deef8d2e3cf2629c68807ffdef2cc5/contracts/Options/HegicETHOptions.sol#L121
