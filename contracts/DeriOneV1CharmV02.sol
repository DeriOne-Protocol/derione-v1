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

    function _getETHCallMarketList(
        IOptionMarketCharmV02[] memory optionMarketList
    ) private view returns (IOptionMarketCharmV02[] memory) {
        uint256 marketCounter;
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
    }
    /// @dev seek for a way to reduce the nested for loop complexity
    function _getETHCallOptionList()
        private
        view
        returns (
            // uint256 _sizeWEI
            DataTypes.Option[] memory
        )
    {
        address[] memory optionMarketAddressList =
            _getOptionMarketAddressList();
        IOptionMarketCharmV02[] memory optionMarketList =
            _getOptionMarketList(optionMarketAddressList);
        IOptionMarketCharmV02[] memory optionMarketETHCallList =
            _getETHCallMarketList(optionMarketList);

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
                uint256 expiry = optionMarketETHCallList[i].expiryTime();
                uint256 strike = optionMarketETHCallList[i].strikePrices(count);
                // uint256 premiumWEI = calculatePremium(_sizeWEI);

                uint256 optionCounter;
                if (i == 0) {
                    optionCounter = count;
                } else if (i > 0) {
                    optionCounter = (i * strikeCount) + count;
                }

                ETHCallOptionList[optionCounter] = DataTypes.Option(
                    DataTypes.UnderlyingAsset.ETH,
                    DataTypes.OptionType.Call,
                    expiry, // a unix timestamp
                    strike,
                    0
                );
            }
        }

        return ETHCallOptionList;
    }

    function getMatchedOptionListCharmV02(
        uint256 _expiryInTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _sizeWEI
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory ETHCallOptionList = _getETHCallOptionList();
        // _sizeWEI

        uint256 matchedCount;

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryInTimestamp &&
                _minStrikeUSD < ETHCallOptionList[i].strikeUSD &&
                ETHCallOptionList[i].strikeUSD < _maxStrikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        DataTypes.Option[] memory matchedETHCallOptionList =
            new DataTypes.Option[](matchedCount);

        for (uint256 i = 0; i < ETHCallOptionList.length; i++) {
            if (
                block.timestamp < ETHCallOptionList[i].expiryTimestamp &&
                ETHCallOptionList[i].expiryTimestamp < _expiryInTimestamp &&
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
