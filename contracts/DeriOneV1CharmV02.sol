// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/ICharmV02OptionFactory.sol";
import "./interfaces/ICharmV02OptionMarket.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1CharmV02 is Ownable {
    using SafeMath for uint256;

    ICharmV02OptionFactory private CharmV02OptionFactoryInstance;

    struct OptionCharmV02 {
        DataTypes.UnderlyingAsset underlyingAsset;
        DataTypes.OptionType optionType;
        uint256 expiry;
        uint256 strikeUSD;
        uint256 premiumWEI;
    }
    constructor(address _charmV02OptionFactoryAddress) public {
        instantiateCharmV02OptionFactory(_charmV02OptionFactoryAddress);
    }

    /// @param _charmV02OptionFactoryAddress CharmV02 OptionFactoryAddress
    function instantiateCharmV02OptionFactory(
        address _charmV02OptionFactoryAddress
    ) public onlyOwner {
        CharmV02OptionFactoryInstance = ICharmV02OptionFactory(
            _charmV02OptionFactoryAddress
        );
    }

    function _getCharmV02OptionMarketAddressList()
        private
        view
        returns (address[] memory)
    {
        uint256 marketsCount = CharmV02OptionFactoryInstance.numMarkets();
        address[] memory optionMarketAddressList = new address[](marketsCount);
        for (uint256 i = 0; i < marketsCount; i++) {
            optionMarketAddressList[i] = CharmV02OptionFactoryInstance.markets(
                i
            );
        }
        return optionMarketAddressList;
    }

    /// @param _charmV02OptionMarketAddressList CharmV02 OptionMarketAddressList
    function _getCharmV02OptionMarketInstanceList(
        address[] memory _charmV02OptionMarketAddressList
    ) private pure returns (ICharmV02OptionMarket[] memory) {
        ICharmV02OptionMarket[] memory optionMarketInstanceList =
            new ICharmV02OptionMarket[](
                _charmV02OptionMarketAddressList.length
            );
        for (uint256 i = 0; i < _charmV02OptionMarketAddressList.length; i++) {
            optionMarketInstanceList[i] = ICharmV02OptionMarket(
                _charmV02OptionMarketAddressList[i]
            );
        }
        return optionMarketInstanceList;
    }

    function _getCharmV02ETHCallList(
        ICharmV02OptionMarket[] memory optionMarketInstanceList
    ) private view returns (ICharmV02OptionMarket[] memory) {
        uint256 instanceCounter;
        for (uint256 i = 0; i < optionMarketInstanceList.length; i++) {
            if (
                optionMarketInstanceList[i].baseToken() == address(0) &&
                optionMarketInstanceList[i].isPut() == false
            ) {
                instanceCounter = instanceCounter.add(1);
            }
        }

        ICharmV02OptionMarket[] memory optionMarketETHCallListInstanceList =
            new ICharmV02OptionMarket[](instanceCounter);

        for (uint256 i = 0; i < optionMarketInstanceList.length; i++) {
            if (
                optionMarketInstanceList[i].baseToken() == address(0) &&
                optionMarketInstanceList[i].isPut() == false
            ) {
                optionMarketETHCallListInstanceList[i] = ICharmV02OptionMarket(
                    CharmV02OptionFactoryInstance.markets(i)
    /// @dev seek for a way to reduce the nested for loop complexity
    function _getETHCallOptionList(
        // uint256 _sizeWEI
        )
        public
        view
        returns (OptionCharmV02[] memory)
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

        OptionCharmV02[] memory ETHCallOptionList =
            new OptionCharmV02[](optionCount);

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

                ETHCallOptionList[optionCounter] = OptionCharmV02(
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

}
