// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IETHOptionHegicV888.sol";
import "./interfaces/IWBTCOptionHegicV888.sol";
import "./interfaces/IETHPoolHegicV888.sol";
import "./interfaces/IWBTCPoolHegicV888.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1HegicV888 is Ownable {
    using SafeMath for uint256;

    IETHOptionHegicV888 private ETHOptionHegicV888;
    IWBTCOptionHegicV888 private WBTCOptionHegicV888;
    IETHPoolHegicV888 private ETHPoolHegicV888;
    IWBTCPoolHegicV888 private WBTCPoolHegicV888;

    uint256[] public expiriesSecondsFromNowStandard = [
        1 days,
        1 weeks,
        2 weeks,
        3 weeks,
        4 weeks
    ];
    uint256[] public strikesStandard;

    constructor(
        address _ETHOptionAddressHegicV888,
        address _WBTCOptionAddressHegicV888,
        address _ETHPoolAddressHegicV888,
        address _WBTCPoolAddressHegicV888,
        uint256 _strikesRange
    ) public {
        instantiateOptionContracts(
            _ETHOptionAddressHegicV888,
            _WBTCOptionAddressHegicV888
        );
        instantiatePoolContracts(
            _ETHPoolAddressHegicV888,
            _WBTCPoolAddressHegicV888
        );
        updateStrikesStandard(_strikesRange);
    }

    function instantiateOptionContracts(
        address _ETHOptionAddressHegicV888,
        address _WBTCOptionAddressHegicV888
    ) public onlyOwner {
        ETHOptionHegicV888 = IETHOptionHegicV888(_ETHOptionAddressHegicV888);
        WBTCOptionHegicV888 = IWBTCOptionHegicV888(_WBTCOptionAddressHegicV888);
    }

    function instantiatePoolContracts(
        address _ETHPoolAddressHegicV888,
        address _WBTCPoolAddressHegicV888
    ) public onlyOwner {
        ETHPoolHegicV888 = IETHPoolHegicV888(_ETHPoolAddressHegicV888);
        WBTCPoolHegicV888 = IWBTCPoolHegicV888(_WBTCPoolAddressHegicV888);
    }

    function updateStrikesStandard(uint256 _strikesRange) public onlyOwner {
        delete strikesStandard;
        for (uint256 i = 0; i < _strikesRange; i++) {
            strikesStandard.push(i.mul(5).mul(10**8));
        }
    }

    function hasEnoughLiquidityHegicV888(
        DataTypes.Asset _underlyingAsset,
        uint256 _size
    ) internal view returns (bool) {
        if (_underlyingAsset == DataTypes.Asset.ETH) {
            uint256 sizeWEI = _size;
            // `(Total ETH in contract) * 0.8 - the amount utilized for options`
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
            uint256 maxSizeWEI = availableBalance.sub(amountUtilized);

            // what happens when the value of a uint256 is negative?
            // is this equation right?
            if (maxSizeWEI > sizeWEI) {
                return true;
            } else if (maxSizeWEI <= sizeWEI) {
                return false;
            }
        } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
            uint256 sizeWBTC = _size; // 8 decimals
            // `(Total WBTC in contract) * 0.8 - the amount utilized for options`
            uint256 availableBalance =
                WBTCPoolHegicV888.totalBalance().mul(8).div(10);
            uint256 amountUtilized =
                WBTCPoolHegicV888.totalBalance().sub(
                    WBTCPoolHegicV888.availableBalance()
                );

            require(
                availableBalance > amountUtilized,
                "there is not enough available balance"
            );
            uint256 maxSizeWBTC = availableBalance.sub(amountUtilized);
            // what happens when the value of a uint256 is negative?
            // is this equation right?
            if (maxSizeWBTC > sizeWBTC) {
                return true;
            } else if (maxSizeWBTC <= sizeWBTC) {
                return false;
            }
        }
    }

    function getOptionFromExactValuesHegicV888(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _strikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option memory) {
        uint256 expiryTimestamp = block.timestamp + _expirySecondsFromNow;
        if (_underlyingAsset == DataTypes.Asset.ETH) {
            uint256 sizeWEI = _size;
            (uint256 minimumPremiumWEI, , , ) =
                ETHOptionHegicV888.fees(
                    _expirySecondsFromNow,
                    sizeWEI,
                    _strikeUSD,
                    uint8(_optionType)
                );

            // the only payment method is ETH now
            DataTypes.Option memory ETHOption =
                DataTypes.Option(
                    DataTypes.Protocol.HegicV888,
                    DataTypes.Asset.ETH,
                    DataTypes.Asset.ETH,
                    _optionType,
                    expiryTimestamp,
                    _strikeUSD,
                    sizeWEI,
                    minimumPremiumWEI
                );
            return ETHOption;
        } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
            uint256 sizeWBTC = _size; // 8 decimals
            (uint256 minimumPremiumWBTC, , , , ) =
                WBTCOptionHegicV888.fees(
                    _expirySecondsFromNow,
                    sizeWBTC,
                    _strikeUSD,
                    uint8(_optionType)
                );

            DataTypes.Option memory WBTCOption =
                DataTypes.Option(
                    DataTypes.Protocol.HegicV888,
                    DataTypes.Asset.WBTC,
                    DataTypes.Asset.ETH,
                    _optionType,
                    expiryTimestamp,
                    _strikeUSD,
                    sizeWBTC,
                    minimumPremiumWBTC
                );
            return WBTCOption;
        }
    }

    function _constructOptionStandardList(
        DataTypes.UnderlyingAsset _underlyingAsset
    ) private view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionStandardList =
            new DataTypes.Option[](
                expiriesSecondsFromNowStandard.length.mul(
                    strikesStandard.length
                )
            );

        for (
            uint256 expiryCount = 0;
            expiryCount < expiriesSecondsFromNowStandard.length;
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

                if (_underlyingAsset == DataTypes.Asset.ETH) {
                    optionStandardList[optionCounter] = DataTypes.Option(
                        DataTypes.Protocol.HegicV888,
                        DataTypes.Asset.ETH,
                        DataTypes.Asset.ETH,
                        DataTypes.OptionType.Invalid,
                        expiriesSecondsFromNowStandard[expiryCount].add(
                            block.timestamp
                        ),
                        strikesStandard[strikeCount],
                        0,
                        0
                    );
                } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
                    optionStandardList[optionCounter] = DataTypes.Option(
                        DataTypes.Protocol.HegicV888,
                        DataTypes.Asset.WBTC,
                        DataTypes.Asset.ETH,
                        DataTypes.OptionType.Invalid,
                        expiriesSecondsFromNowStandard[expiryCount].add(
                            block.timestamp
                        ),
                        strikesStandard[strikeCount],
                        0,
                        0
                    );
                }
            }
        }
        return optionStandardList;
    }

    function _getMatchedOptionList(
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size,
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

        uint256 matchedCount = 0;
        for (uint256 i = 0; i < _optionStandardList.length; i++) {
            if (
                block.timestamp < _optionStandardList[i].expiryTimestamp &&
                _optionStandardList[i].expiryTimestamp < expiryTimestamp &&
                _minStrikeUSD < _optionStandardList[i].strikeUSD &&
                _optionStandardList[i].strikeUSD < _maxStrikeUSD
            ) {
                matchedOptionList[matchedCount] = DataTypes.Option(
                    DataTypes.Protocol.HegicV888,
                    _optionStandardList[i].underlyingAsset,
                    DataTypes.Asset.ETH,
                    _optionType,
                    _optionStandardList[i].expiryTimestamp,
                    _optionStandardList[i].strikeUSD,
                    _size,
                    0
                );
                matchedCount = matchedCount.add(1);
            }
        }
        return matchedOptionList;
    }

    function getOptionListFromRangeValuesHegicV888(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expirySecondsFromNow,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionStandardList =
            _constructOptionStandardList(_underlyingAsset);
        DataTypes.Option[] memory optionList =
            _getMatchedOptionList(
                _optionType,
                _expirySecondsFromNow,
                _minStrikeUSD,
                _maxStrikeUSD,
                _size,
                optionStandardList
            );

        for (uint256 i = 0; i < optionList.length; i++) {
            uint256 expirySecondsFromNow =
                optionList[i].expiryTimestamp.sub(block.timestamp);
            if (_underlyingAsset == DataTypes.Asset.ETH) {
                (uint256 minimumPremiumWEI, , , ) =
                    ETHOptionHegicV888.fees(
                        expirySecondsFromNow,
                        _size,
                        optionList[i].strikeUSD,
                        uint8(_optionType)
                    );
                optionList[i].premium = minimumPremiumWEI;
            } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
                (uint256 minimumPremiumWBTC, , , , ) =
                    WBTCOptionHegicV888.fees(
                        _expirySecondsFromNow,
                        _size,
                        optionList[i].strikeUSD,
                        uint8(_optionType)
                    );
                optionList[i].premium = minimumPremiumWBTC;
            }
        }

        return optionList;
    }
}

// you need to use require for strike price and expiry and possibly in other places
// the hegic has some require
// https://github.com/hegic/contracts-v888/blob/ecdc7816c1deef8d2e3cf2629c68807ffdef2cc5/contracts/Options/HegicETHOptions.sol#L121
