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

    constructor(address _optionFactoryAddressCharmV02) public {
        instantiateOptionFactoryCharmV02(_optionFactoryAddressCharmV02);
    }

    /// @param _optionFactoryAddressCharmV02 CharmV02 OptionFactoryAddress
    function instantiateOptionFactoryCharmV02(
        address _optionFactoryAddressCharmV02
    ) public onlyOwner {
        OptionFactoryCharmV02 = IOptionFactoryCharmV02(
            _optionFactoryAddressCharmV02
        );
    }

    function _getOptionMarketAddressList()
        private
        view
        returns (address[] memory)
    {
        uint256 marketsCount = OptionFactoryCharmV02.numMarkets();
        address[] memory optionMarketAddressList = new address[](marketsCount);
        for (uint256 i = 0; i < marketsCount; i++) {
            optionMarketAddressList[i] = OptionFactoryCharmV02.markets(i);
        }
        return optionMarketAddressList;
    }

    /// @param _charmV02OptionMarketAddressList CharmV02 OptionMarketAddressList
    function _getOptionMarketList(
        address[] memory _charmV02OptionMarketAddressList
    ) private pure returns (IOptionMarketCharmV02[] memory) {
        IOptionMarketCharmV02[] memory optionMarketList =
            new IOptionMarketCharmV02[](
                _charmV02OptionMarketAddressList.length
            );
        for (uint256 i = 0; i < _charmV02OptionMarketAddressList.length; i++) {
            optionMarketList[i] = IOptionMarketCharmV02(
                _charmV02OptionMarketAddressList[i]
            );
        }
        return optionMarketList;
    }

    function _getETHMarketList(
        DataTypes.OptionType _optionType,
        IOptionMarketCharmV02[] memory optionMarketList
    ) private view returns (IOptionMarketCharmV02[] memory) {
        uint256 marketCounter;
        if(_optionType == DataTypes.OptionType.Call) {
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
    /// @dev seek for a way to reduce the nested for loop complexity
    function _getETHOptionList(DataTypes.OptionType _optionType, uint256 _sizeWEI)
        private
        view
        returns (DataTypes.Option[] memory)
    {
        address[] memory optionMarketAddressList =
            _getOptionMarketAddressList();
        IOptionMarketCharmV02[] memory optionMarketList =
            _getOptionMarketList(optionMarketAddressList);
        IOptionMarketCharmV02[] memory optionMarketETHCallList =
            _getETHMarketList(_optionType, optionMarketList);

        uint256 optionCount;

        for (uint256 i = 0; i < optionMarketETHCallList.length; i++) {
            uint256 strikeCount = optionMarketETHCallList[i].numStrikes();
            for (uint256 count = 0; count < strikeCount; count++) {
                optionCount = optionCount.add(1);
            }
        }

        DataTypes.Option[] memory ETHCallOptionList =
            new DataTypes.Option[](optionCount);

        for (uint256 i = 0; i < optionMarketETHCallList.length; i++) {
            uint256 strikeCount = optionMarketETHCallList[i].numStrikes();
            for (uint256 count = 0; count < strikeCount; count++) {
                uint256 strike = optionMarketETHCallList[i].strikePrices(count);
                uint256 expiryTimestamp = optionMarketETHCallList[i].expiryTime();
                // uint256 premiumWEI = calculatePremium(_sizeWEI);

                uint256 optionCounter;
                if (i == 0) {
                    optionCounter = count;
                } else if (i > 0) {
                    optionCounter = (i * strikeCount) + count;
                }

                ETHCallOptionList[optionCounter] = DataTypes.Option(
                    DataTypes.Protocol.CharmV02,
                    DataTypes.UnderlyingAsset.ETH,
                    DataTypes.OptionType.Call,
                    expiryTimestamp,
                    strikeUSD,
                    _sizeWEI,
                    0
                );
            }
        }

        return ETHCallOptionList;
    }

    function getETHOptionFromExactValuesCharmV02(
    function getMatchedCountFromExactValues(
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        DataTypes.OptionType _optionType,
        uint256 _sizeWEI
    ) private view returns(uint256) {
        DataTypes.Option[] memory ETHCallOptionList = _getETHOptionList(_optionType, _sizeWEI);
        // _sizeWEI

        uint256 matchedCount;

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == ETHCallOptionList[i].strikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }
    function getETHOptionFromExactValuesCharmV02(
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        DataTypes.OptionType _optionType,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option memory) {
        DataTypes.Option[] memory ETHCallOptionList = _getETHOptionList(_optionType, _sizeWEI);
        // _sizeWEI

        uint256 matchedCount = getMatchedCountFromExactValues(_expiryTimestamp, _strikeUSD, _optionType, _sizeWEI);

        if(matchedCount == 0) {
            DataTypes.Option memory matchedETHCallOption = DataTypes.Option(
                DataTypes.Protocol.Invalid,
                DataTypes.UnderlyingAsset.ETH,
                DataTypes.OptionType.Invalid,
                0,
                0,
                0,
                0
            );
            return matchedETHCallOption;
        }

        DataTypes.Option[] memory matchedETHCallOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == ETHCallOptionList[i].strikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedETHCallOptionList[count] = ETHCallOptionList[i];
                }
            }
        }

        DataTypes.Option memory matchedETHCallOption = matchedETHCallOptionList[0];

        return matchedETHCallOption;
    }

    function getMatchedCountFromRangeValues(
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) private view returns(uint256) {
        DataTypes.Option[] memory ETHCallOptionList = _getETHOptionList(_optionType, _sizeWEI);
        // _sizeWEI

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
        DataTypes.Option[] memory ETHCallOptionList = _getETHOptionList(_optionType, _sizeWEI);
        // _sizeWEI

        uint256 matchedCount = getMatchedCountFromRangeValues(_optionType, _expiryTimestamp, _minStrikeUSD, _maxStrikeUSD, _sizeWEI);

        DataTypes.Option[] memory matchedETHCallOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryTimestamp &&
                _minStrikeUSD < ETHCallOptionList[i].strikeUSD &&
                ETHCallOptionList[i].strikeUSD < _maxStrikeUSD
            ) {
                for (uint256 count = 0; count < matchedCount; count++) {
                    matchedETHCallOptionList[count] = ETHCallOptionList[i];
                }
            }
        }

        return matchedETHCallOptionList;
    }
}
