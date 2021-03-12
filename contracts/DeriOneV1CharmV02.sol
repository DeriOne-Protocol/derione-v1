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

    function _getETHMarketList(
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory optionMarketList
    ) private view returns (IOptionMarketCharmV02[] memory) {
        uint256 marketCounter;
        if (_optionType == DataTypes.OptionType.Call) {
            for (uint256 i = 0; i < optionMarketList.length; i++) {
                if (
                    optionMarketList[i].baseToken() == address(0) &&
                    optionMarketList[i].isPut() == false
                ) {
                    marketCounter = marketCounter.add(1);
                }
            }

            IOptionMarketCharmV02[] memory optionMarketETHCallList =
                new IOptionMarketCharmV02[](marketCounter);

            for (uint256 i = 0; i < optionMarketList.length; i++) {
                if (
                    optionMarketList[i].baseToken() == address(0) &&
                    optionMarketList[i].isPut() == false
                ) {
                    optionMarketETHCallList[i] = IOptionMarketCharmV02(
                        OptionFactoryCharmV02.markets(i)
                    );
                }
            }

            return optionMarketETHCallList;
        } else if (_optionType == DataTypes.OptionType.Put) {
            for (uint256 i = 0; i < optionMarketList.length; i++) {
                if (
                    optionMarketList[i].baseToken() == address(0) &&
                    optionMarketList[i].isPut() == true
                ) {
                    marketCounter = marketCounter.add(1);
                }
            }

            IOptionMarketCharmV02[] memory optionMarketETHPutList =
                new IOptionMarketCharmV02[](marketCounter);

            for (uint256 i = 0; i < optionMarketList.length; i++) {
                if (
                    optionMarketList[i].baseToken() == address(0) &&
                    optionMarketList[i].isPut() == true
                ) {
                    optionMarketETHPutList[i] = IOptionMarketCharmV02(
                        OptionFactoryCharmV02.markets(i)
                    );
                }
            }

            return optionMarketETHPutList;
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

    function getETHOptionFromExactValuesCharmV02(
    function getMatchedCountFromExactValues(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _sizeWEI
    ) internal view returns (uint256) {
        DataTypes.Option[] memory ETHOptionList =
            _getETHOptionList(_optionType, _sizeWEI);

        uint256 matchedCount;

        for (uint256 i = 0; i < ETHOptionList.length; i++) {
            if (
                block.timestamp < ETHOptionList[i].expiryTimestamp &&
                ETHOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == ETHOptionList[i].strikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }

    function getETHOptionFromExactValuesCharmV02(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option memory) {
        DataTypes.Option[] memory ETHOptionList =
            _getETHOptionList(_optionType, _sizeWEI);

        uint256 matchedCount =
            getMatchedCountFromExactValues(
                _optionType,
                _expiryTimestamp,
                _strikeUSD,
                _sizeWEI
            );

        DataTypes.Option[] memory matchedETHOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < ETHOptionList.length; i++) {
            if (
                block.timestamp < ETHOptionList[i].expiryTimestamp &&
                ETHOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == ETHOptionList[i].strikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedETHOptionList[count] = ETHOptionList[i];
                }
            }
        }

        DataTypes.Option memory matchedETHOption = matchedETHOptionList[0];

        return matchedETHOption;
    }

    function getMatchedCountFromRangeValues(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) internal view returns (uint256) {
        DataTypes.Option[] memory ETHCallOptionList =
            _getETHOptionList(_optionType, _sizeWEI);

        uint256 matchedCount;

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _minStrikeUSD < ETHCallOptionList[i].strikeUSD &&
                ETHCallOptionList[i].strikeUSD < _maxStrikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }

    function getETHOptionListFromRangeValuesCharmV02(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory ETHOptionList =
            _getETHOptionList(_optionType, _sizeWEI);

        uint256 matchedCount =
            getMatchedCountFromRangeValues(
                _optionType,
                _expiryTimestamp,
                _minStrikeUSD,
                _maxStrikeUSD,
                _sizeWEI
            );

        DataTypes.Option[] memory matchedETHOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < ETHOptionList.length; i++) {
            if (
                block.timestamp < ETHOptionList[i].expiryTimestamp &&
                ETHOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _minStrikeUSD < ETHOptionList[i].strikeUSD &&
                ETHOptionList[i].strikeUSD < _maxStrikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedETHOptionList[count] = ETHOptionList[i];
                }
            }
        }

        return matchedETHOptionList;
    }
}
