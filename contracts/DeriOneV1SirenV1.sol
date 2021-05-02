// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IMarketSirenV1.sol";
import "./interfaces/IMinterAmmSirenV1.sol";
import "./libraries/Constants.sol";
import "./libraries/Conversion.sol";
import "./libraries/DataTypes.sol";
import "./libraries/Strings.sol";

contract DeriOneV1SirenV1 is Ownable {
    using Conversion for *;
    using SafeMath for uint256;
    using Strings for string;

    IMinterAmmSirenV1 public MinterAmmSirenV1;
    IMarketSirenV1 public MarketSirenV1;

    IMinterAmmSirenV1[] public minterAmmInstanceList;
    address[] public marketAddressList;
    IMarketSirenV1[] public marketInstanceList;

    constructor(address[] memory _minterAmmAddressList) public {
        init(_minterAmmAddressList);
    }

    function init(address[] memory _minterAmmAddressList) public onlyOwner {
        delete marketAddressList;
        delete minterAmmInstanceList;
        delete marketInstanceList;
        _instantiateMinterAmm(_minterAmmAddressList);
        _getMarketAddressList(minterAmmInstanceList);
        _instantiateMarket(marketAddressList);
    }

    function _instantiateMinterAmm(address[] memory _minterAmmAddressList)
        private
    {
        for (uint256 i = 0; i < _minterAmmAddressList.length; i++) {
            minterAmmInstanceList.push(
                IMinterAmmSirenV1(_minterAmmAddressList[i])
            );
        }
    }

    function _getMarketAddressList(
        IMinterAmmSirenV1[] memory _minterAmmInstanceList
    ) private {
        for (uint256 i = 0; i < _minterAmmInstanceList.length; i++) {
            address[] memory markets = _minterAmmInstanceList[i].getMarkets();
            for (
                uint256 marketNum = 0;
                marketNum < markets.length;
                marketNum++
            ) {
                marketAddressList.push(markets[marketNum]);
            }
        }
    }

    function _instantiateMarket(address[] memory _marketAddressList) private {
        for (uint256 i = 0; i < _marketAddressList.length; i++) {
            marketInstanceList.push(IMarketSirenV1(_marketAddressList[i]));
        }
    }

    function _calculatePremiumSirenV1(uint256 _size)
        private
        view
        returns (uint256)
    {}

    function _getOptionListSirenV1()
        private
        view
        returns (DataTypes.Option[] memory)
    {
        // remove view?
        DataTypes.Option[] memory optionList =
            new DataTypes.Option[](marketInstanceList.length);
        for (uint256 i = 0; i < marketInstanceList.length; i++) {
            // a market name in the form of payment.collateral.expiry.option_type.strike
            string memory marketName = marketInstanceList[i].marketName();
            string[] memory split = marketName.split(".");

            DataTypes.Asset underlyingAsset;
            if (
                marketInstanceList[i].collateralToken() ==
                Constants.getSUSHITokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.SUSHI;
            } else if (
                marketInstanceList[i].collateralToken() ==
                Constants.getUNITokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.UNI;
            } else if (
                marketInstanceList[i].collateralToken() ==
                Constants.getUSDCTokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.USDC;
            } else if (
                marketInstanceList[i].collateralToken() ==
                Constants.getWBTCTokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.WBTC;
            } else if (
                marketInstanceList[i].collateralToken() ==
                Constants.getWETHTokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.WETH;
            } else if (
                marketInstanceList[i].collateralToken() ==
                Constants.getYFITokenAddress()
            ) {
                underlyingAsset = DataTypes.Asset.YFI;
            }

            DataTypes.Asset paymentAsset;
            if (
                marketInstanceList[i].paymentToken() ==
                Constants.getSUSHITokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.SUSHI;
            } else if (
                marketInstanceList[i].paymentToken() ==
                Constants.getUNITokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.UNI;
            } else if (
                marketInstanceList[i].paymentToken() ==
                Constants.getUSDCTokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.USDC;
            } else if (
                marketInstanceList[i].paymentToken() ==
                Constants.getWBTCTokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.WBTC;
            } else if (
                marketInstanceList[i].paymentToken() ==
                Constants.getWETHTokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.WETH;
            } else if (
                marketInstanceList[i].paymentToken() ==
                Constants.getYFITokenAddress()
            ) {
                paymentAsset = DataTypes.Asset.YFI;
            }
            // instead of storing an address in our contract, we can get the symbol from the erc20 interface.

            DataTypes.OptionType optionType;
            if (
                keccak256(bytes(split[split.length - 2])) ==
                keccak256(bytes("P"))
            ) {
                optionType = DataTypes.OptionType.Put;
            } else if (
                keccak256(bytes(split[split.length - 2])) ==
                keccak256(bytes("C"))
            ) {
                optionType = DataTypes.OptionType.Call;
            }

            uint256 strikeUSD =
                Conversion.stringToUint(split[split.length - 1]).mul(10**8);

            optionList[i] = DataTypes.Option(
                DataTypes.Protocol.SirenV1,
                underlyingAsset,
                paymentAsset,
                optionType,
                marketInstanceList[i].expirationDate(),
                strikeUSD,
                0, // size should be passed in a parameter
                0 // premium should be calculated
            );
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
        DataTypes.Option[] memory optionList = _getOptionListSirenV1();

        uint256 matchedCount;

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                _underlyingAsset == optionList[i].underlyingAsset &&
                _optionType == optionList[i].optionType &&
                block.timestamp < optionList[i].expiryTimestamp &&
                optionList[i].expiryTimestamp < _expiryTimestamp &&
                _strikeUSD == optionList[i].strikeUSD
            ) {
                matchedCount = matchedCount.add(1);
            }
        }

        return matchedCount;
    }

    function getOptionFromExactValuesSirenV1(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _strikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option memory) {
        DataTypes.Option[] memory optionList = _getOptionListSirenV1();

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
        DataTypes.Option memory matchedOption;

        if (matchedCount > 0) {
            for (uint256 i = 0; i < optionList.length; i++) {
                if (
                    _underlyingAsset == optionList[i].underlyingAsset &&
                    _optionType == optionList[i].optionType &&
                    block.timestamp < optionList[i].expiryTimestamp &&
                    optionList[i].expiryTimestamp < _expiryTimestamp &&
                    _strikeUSD == optionList[i].strikeUSD
                ) {
                    for (uint256 count = 0; count < matchedCount; count++) {
                        matchedOptionList[count] = optionList[i];
                    }
                }
            }

            matchedOption = matchedOptionList[0]; // this logic is not right. why the first one?

            return matchedOption;
        } else {
            matchedOption = DataTypes.Option(
                DataTypes.Protocol.SirenV1,
                DataTypes.Asset.Invalid,
                DataTypes.Asset.Invalid,
                DataTypes.OptionType.Invalid,
                0,
                0,
                0,
                0
            );

            return matchedOption;
        }
    }

    function _getMatchedCountFromRangeValuesSirenV1(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) private view returns (uint256) {
        DataTypes.Option[] memory optionList = _getOptionListSirenV1();

        uint256 matchedCount;

        for (uint256 i = 0; i < optionList.length; i++) {
            if (
                _underlyingAsset == optionList[i].underlyingAsset &&
                _optionType == optionList[i].optionType &&
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

    function getOptionListFromRangeValuesSirenV1(
        DataTypes.Asset _underlyingAsset,
        DataTypes.OptionType _optionType,
        uint256 _expiryTimestamp,
        uint256 _minStrikeUSD,
        uint256 _maxStrikeUSD,
        uint256 _size
    ) internal view returns (DataTypes.Option[] memory) {
        DataTypes.Option[] memory optionList = _getOptionListSirenV1();

        uint256 matchedCount =
            _getMatchedCountFromRangeValuesSirenV1(
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
                _underlyingAsset == optionList[i].underlyingAsset &&
                _optionType == optionList[i].optionType &&
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
