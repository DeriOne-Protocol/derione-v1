// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IOptionFactoryCharmV02.sol";
import "./interfaces/IOptionMarketCharmV02.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1CharmV02 is Ownable {
    using SafeMath for uint256;

    IOptionFactoryCharmV02 private OptionFactoryCharmV02;

    address public constant WBTC_TOKEN =
        0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

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
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory _optionMarketList
    ) private view returns (uint256) {
        uint256 marketCounter;
        if (_underlyingAsset == DataTypes.UnderlyingAsset.ETH) {
            if (_optionType == DataTypes.OptionType.Call) {
                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == address(0) &&
                        _optionMarketList[i].isPut() == false
                    ) {
                        marketCounter = marketCounter.add(1);
                    }
                }
                return marketCounter;
            } else if (_optionType == DataTypes.OptionType.Put) {
                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == address(0) &&
                        _optionMarketList[i].isPut() == true
                    ) {
                        marketCounter = marketCounter.add(1);
                    }
                }
                return marketCounter;
            }
        } else if (_underlyingAsset == DataTypes.UnderlyingAsset.WBTC) {
            if (_optionType == DataTypes.OptionType.Call) {
                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == WBTC_TOKEN &&
                        _optionMarketList[i].isPut() == false
                    ) {
                        marketCounter = marketCounter.add(1);
                    }
                }
                return marketCounter;
            } else if (_optionType == DataTypes.OptionType.Put) {
                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == WBTC_TOKEN &&
                        _optionMarketList[i].isPut() == true
                    ) {
                        marketCounter = marketCounter.add(1);
                    }
                }
                return marketCounter;
            }
        }
    }

    function _filterMarketWithAssetAndType(
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory _optionMarketList
    ) private view returns (IOptionMarketCharmV02[] memory) {
        uint256 marketCounter =
            _getMarketCountWithAssetAndType(
                _underlyingAsset,
                _optionType,
                _optionMarketList
            );

        if (_underlyingAsset == DataTypes.UnderlyingAsset.ETH) {
            if (_optionType == DataTypes.OptionType.Call) {
                IOptionMarketCharmV02[] memory optionMarketETHCallList =
                    new IOptionMarketCharmV02[](marketCounter);

                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == address(0) &&
                        _optionMarketList[i].isPut() == false
                    ) {
                        optionMarketETHCallList[i] = IOptionMarketCharmV02(
                            OptionFactoryCharmV02.markets(i)
                        );
                    }
                }

                return optionMarketETHCallList;
            } else if (_optionType == DataTypes.OptionType.Put) {
                IOptionMarketCharmV02[] memory optionMarketETHPutList =
                    new IOptionMarketCharmV02[](marketCounter);

                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == address(0) &&
                        _optionMarketList[i].isPut() == true
                    ) {
                        optionMarketETHPutList[i] = IOptionMarketCharmV02(
                            OptionFactoryCharmV02.markets(i)
                        );
                    }
                }

                return optionMarketETHPutList;
            }
        } else if (_underlyingAsset == DataTypes.UnderlyingAsset.WBTC) {
            if (_optionType == DataTypes.OptionType.Call) {
                IOptionMarketCharmV02[] memory optionMarketWBTCCallList =
                    new IOptionMarketCharmV02[](marketCounter);

                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == WBTC_TOKEN &&
                        _optionMarketList[i].isPut() == false
                    ) {
                        optionMarketWBTCCallList[i] = IOptionMarketCharmV02(
                            OptionFactoryCharmV02.markets(i)
                        );
                    }
                }

                return optionMarketWBTCCallList;
            } else if (_optionType == DataTypes.OptionType.Put) {
                IOptionMarketCharmV02[] memory optionMarketWBTCPutList =
                    new IOptionMarketCharmV02[](marketCounter);

                for (uint256 i = 0; i < _optionMarketList.length; i++) {
                    if (
                        _optionMarketList[i].baseToken() == WBTC_TOKEN &&
                        _optionMarketList[i].isPut() == true
                    ) {
                        optionMarketWBTCPutList[i] = IOptionMarketCharmV02(
                            OptionFactoryCharmV02.markets(i)
                        );
                    }
                }

                return optionMarketWBTCPutList;
            }
        }
    }
        private
        view
    function _getOptionList(
        DataTypes.UnderlyingAsset _underlyingAsset,
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

                optionList[optionCounter] = DataTypes.Option(
                    DataTypes.Protocol.CharmV02,
                    _underlyingAsset,
                    _optionType,
                    optionMarketList[i].expiryTime(),
                    strikeUSD,
                    _size,
                    0
                );
            }
        }

        return optionList;
    }

    function getMatchedCountFromExactValues(
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) internal view returns (uint256) {
        DataTypes.Option[] memory optionList =
            _getOptionList(_underlyingAsset, _optionType, _size);

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
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option memory) {
        DataTypes.Option[] memory optionList =
            _getOptionList(_underlyingAsset, _optionType, _size);

        uint256 matchedCount =
            getMatchedCountFromExactValues(
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

    function getMatchedCountFromRangeValues(
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) internal view returns (uint256) {
        DataTypes.Option[] memory optionList =
            _getOptionList(_underlyingAsset, _optionType, _size);

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
        DataTypes.UnderlyingAsset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionList =
            _getOptionList(_underlyingAsset, _optionType, _size);

        uint256 matchedCount =
            getMatchedCountFromRangeValues(
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
