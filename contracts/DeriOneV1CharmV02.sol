// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IOptionFactoryCharmV02.sol";
import "./interfaces/IOptionMarketCharmV02.sol";
import "./libraries/Constants.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1CharmV02 is Ownable {
    using SafeMath for uint256;

    IOptionFactoryCharmV02 private OptionFactoryCharmV02;

    constructor(address _optionFactoryAddressCharmV02) public {
        instantiateOptionFactoryCharmV02(_optionFactoryAddressCharmV02);
    }

    function instantiateOptionFactoryCharmV02(
        address _optionFactoryAddressCharmV02
    ) public onlyOwner {
        OptionFactoryCharmV02 = IOptionFactoryCharmV02(
            _optionFactoryAddressCharmV02
        );
    }

    function _getAllOptionMarketAddresses()
        private
        view
        returns (address[] memory)
    {
        uint256 marketsCount = OptionFactoryCharmV02.numMarkets();
        address[] memory allOptionMarketAddresses = new address[](marketsCount);
        for (uint256 i = 0; i < marketsCount; i++) {
            allOptionMarketAddresses[i] = OptionFactoryCharmV02.markets(i);
        }
        return allOptionMarketAddresses;
    }

    function _getAllOptionMarkets(
        address[] memory _charmV02OptionMarketAddressList
    ) private pure returns (IOptionMarketCharmV02[] memory) {
        IOptionMarketCharmV02[] memory allOptionMarkets =
            new IOptionMarketCharmV02[](
                _charmV02OptionMarketAddressList.length
            );
        for (uint256 i = 0; i < _charmV02OptionMarketAddressList.length; i++) {
            allOptionMarkets[i] = IOptionMarketCharmV02(
                _charmV02OptionMarketAddressList[i]
            );
        }
        return allOptionMarkets;
    }

    function _getMarketCountWithAssetAndType(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory _optionMarketList
    ) private view returns (uint256) {
        uint256 marketCounter;
        address baseToken;
        if (_underlyingAsset == DataTypes.Asset.ETH) {
            baseToken = address(0);
        } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
            baseToken = Constants.getWBTCTokenAddress();
        }
        bool isPut;
        if (_optionType == DataTypes.OptionType.Call) {
            isPut = false;
        } else if (_optionType == DataTypes.OptionType.Put) {
            isPut = true;
        }

        for (uint256 i = 0; i < _optionMarketList.length; i++) {
            if (
                _optionMarketList[i].baseToken() == baseToken &&
                _optionMarketList[i].isPut() == isPut
            ) {
                marketCounter = marketCounter.add(1);
            }
        }
        return marketCounter;
    }

    function _filterMarketWithAssetAndType(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory _optionMarketList
    ) private view returns (IOptionMarketCharmV02[] memory) {
        uint256 marketCounter =
            _getMarketCountWithAssetAndType(
                _underlyingAsset,
                _optionType,
                _optionMarketList
            );

        IOptionMarketCharmV02[] memory optionMarketList =
            new IOptionMarketCharmV02[](marketCounter);

        address baseToken;
        if (_underlyingAsset == DataTypes.Asset.ETH) {
            baseToken = address(0);
        } else if (_underlyingAsset == DataTypes.Asset.WBTC) {
            baseToken = Constants.getWBTCTokenAddress();
        }
        bool isPut;
        if (_optionType == DataTypes.OptionType.Call) {
            isPut = false;
        } else if (_optionType == DataTypes.OptionType.Put) {
            isPut = true;
        }

        uint256 matchedCount = 0;
        for (uint256 i = 0; i < _optionMarketList.length; i++) {
            if (
                _optionMarketList[i].baseToken() == baseToken &&
                _optionMarketList[i].isPut() == isPut
            ) {
                optionMarketList[matchedCount] = IOptionMarketCharmV02(
                    OptionFactoryCharmV02.markets(i)
                );
                matchedCount = matchedCount.add(1);
            }
        }

        return optionMarketList;
    }
        private
        view
    function _getOptionListCharmV02(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _size
    ) private view returns (DataTypes.Option[] memory) {
        address[] memory allOptionMarketAddresses =
            _getAllOptionMarketAddresses();
        IOptionMarketCharmV02[] memory allOptionMarkets =
            _getAllOptionMarkets(allOptionMarketAddresses);
        IOptionMarketCharmV02[] memory optionMarketList =
            _filterMarketWithAssetAndType(
                _underlyingAsset,
                _optionType,
                allOptionMarkets
            );

        uint256 optionCount;

        for (uint256 i = 0; i < optionMarketList.length; i++) {
            uint256 strikeCount = optionMarketList[i].numStrikes();
            for (uint256 count = 0; count < strikeCount; count++) {
                optionCount = optionCount.add(1);
            }
        }

        DataTypes.Option[] memory optionList =
            new DataTypes.Option[](optionCount);

        for (uint256 i = 0; i < optionMarketList.length; i++) {
            uint256 strikeCount = optionMarketList[i].numStrikes();
            for (uint256 count = 0; count < strikeCount; count++) {
                uint256 strikeUSD = optionMarketList[i].strikePrices(count);
                strikeUSD = strikeUSD.div(10**10); //convert 18 decimals to 8 decimals.
                // uint256 premiumWEI = calculatePremium(_size);

                uint256 optionCounter;
                if (i == 0) {
                    optionCounter = count;
                } else if (i > 0) {
                    optionCounter = (i * strikeCount) + count;
                }

                // call options are paid with underlyng asset and put options are paid with USDC
                if (_optionType == DataTypes.OptionType.Call) {
                    optionList[optionCounter] = DataTypes.Option(
                        DataTypes.Protocol.CharmV02,
                        _underlyingAsset,
                        _underlyingAsset,
                        _optionType,
                        optionMarketList[i].expiryTime(),
                        strikeUSD,
                        _size,
                        0
                    );
                } else if (_optionType == DataTypes.OptionType.Put) {
                    optionList[optionCounter] = DataTypes.Option(
                        DataTypes.Protocol.CharmV02,
                        _underlyingAsset,
                        DataTypes.Asset.USDC,
                        _optionType,
                        optionMarketList[i].expiryTime(),
                        strikeUSD,
                        _size,
                        0
                    );
                }
            }
        }

        return optionList;
    }

    function _getMatchedCountFromExactValues(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) private view returns (uint256) {
        DataTypes.Option[] memory optionList =
            _getOptionListCharmV02(_underlyingAsset, _optionType, _size);

        uint256 matchedCount;

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                block.timestamp < optionList[i].expiryTimestamp &&
                optionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == optionList[i].strikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }

    function getOptionFromExactValuesCharmV02(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option memory) {
        DataTypes.Option[] memory optionList =
            _getOptionListCharmV02(_underlyingAsset, _optionType, _size);

        uint256 matchedCount =
            _getMatchedCountFromExactValues(
                _underlyingAsset,
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _size
            );

        DataTypes.Option[] memory matchedOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                block.timestamp < optionList[i].expiryTimestamp &&
                optionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == optionList[i].strikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedOptionList[count] = optionList[i];
                }
            }
        }

        DataTypes.Option memory matchedOption = matchedOptionList[0];

        return matchedOption;
    }

    function _getMatchedCountFromRangeValuesCharmV02(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) private view returns (uint256) {
        DataTypes.Option[] memory optionList =
            _getOptionListCharmV02(_underlyingAsset, _optionType, _size);

        uint256 matchedCount;

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                block.timestamp < optionList[i].expiryTimestamp &&
                optionList[i].expiryTimestamp < _expiryTimestamp &&
                _minStrikeUSD < optionList[i].strikeUSD &&
                optionList[i].strikeUSD < _maxStrikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }

    function getOptionListFromRangeValuesCharmV02(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionList =
            _getOptionListCharmV02(_underlyingAsset, _optionType, _size);

        uint256 matchedCount =
            _getMatchedCountFromRangeValuesCharmV02(
                _underlyingAsset,
                _optionType,
                _expiryTimestamp,
                _minStrikeUSD,
                _maxStrikeUSD,
                _size
            );

        DataTypes.Option[] memory matchedOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                block.timestamp < optionList[i].expiryTimestamp &&
                optionList[i].expiryTimestamp < _expiryTimestamp &&
                _minStrikeUSD < optionList[i].strikeUSD &&
                optionList[i].strikeUSD < _maxStrikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedOptionList[count] = optionList[i];
                }
            }
        }

        return matchedOptionList;
    }
}
