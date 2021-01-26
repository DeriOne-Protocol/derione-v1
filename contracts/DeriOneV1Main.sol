// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./DeriOneV1HegicV888.sol";
import "./libraries/DataTypes.sol";

/// @author tai
/// @notice For now, this contract gets the cheapest ETH/WETH put options price from Opyn V1 and Hegic V888
/// @dev explicitly state the data location for all variables of struct, array or mapping types (including function parameters)
/// @dev adjust visibility of variables. they should be all private by default i guess
/// @dev optimize gas consumption
contract DeriOneV1Main is DeriOneV1HegicV888 {
    enum Protocol {HegicV888, Invalid}
    struct Option {
        Protocol protocol;
        DataTypes.UnderlyingAsset underlyingAsset;
        DataTypes.OptionType optionType;
        uint256 expiry;
        uint256 strikeUSD;
        uint256 sizeWEI;
        uint256 premiumWEI;
    }

    constructor(
        address _hegicETHOptionV888Address,
        address _hegicETHPoolV888Address
    )
        public
        DeriOneV1HegicV888(_hegicETHOptionV888Address, _hegicETHPoolV888Address)
    {}

    /// @notice get the cheapest ETH put option across protocols
    /// @param _expiry expiration date in seconds from now
    /// @param _strikeUSD strike price in USD with 8 decimals
    /// @param _sizeWEI option size in WEI
    function getTheCheapestETHPut(
        uint256 _expiry,
        uint256 _strikeUSD,
        uint256 _sizeWEI
    ) public view returns (Option memory) {
        // require expiry. check if it is after the latest block time

        OptionHegicV888 memory ETHPutHegicV888 =
            getETHPutHegicV888(_expiry, _strikeUSD, _sizeWEI);
        require(
            hasEnoughETHLiquidityHegicV888(_sizeWEI) == true,
            "your size is too big for liquidity in the Hegic V888"
        );
        // the cheapest ETH put option across options protocols
        Option memory theCheapestETHPut =
            Option(
                Protocol.HegicV888,
                DataTypes.UnderlyingAsset.ETH,
                DataTypes.OptionType.Put,
                ETHPutHegicV888.expiry,
                ETHPutHegicV888.strikeUSD,
                _sizeWEI,
                ETHPutHegicV888.premiumWEI
            );
        return theCheapestETHPut;
    }
}
