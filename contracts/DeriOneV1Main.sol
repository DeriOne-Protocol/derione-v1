// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./DeriOneV1HegicV888.sol";

/// @author tai
/// @title A contract for getting the cheapest options price
/// @notice For now, this contract gets the cheapest ETH/WETH put options price from Opyn V1 and Hegic V888
/// @dev explicitly state the data location for all variables of struct, array or mapping types (including function parameters)
/// @dev adjust visibility of variables. they should be all private by default i guess
/// @dev optimize gas consumption
contract DeriOneV1Main is DeriOneV1HegicV888 {
    enum Protocol {HegicV888}
    struct TheCheapestETHPutOption {
        Protocol protocol;
        address oTokenAddress;
        address paymentTokenAddress;
        uint256 expiry;
        uint256 optionSizeInWEI;
        uint256 premiumInWEI;
        uint256 strikeInUSD;
    }

    constructor(
        address _hegicETHOptionV888Address,
        address _hegicETHPoolV888Address
    )
        public
        DeriOneV1HegicV888(_hegicETHOptionV888Address, _hegicETHPoolV888Address)
    {}

    function theCheapestETHPutOption()
        public
        view
        returns (TheCheapestETHPutOption memory)
    {
        return _theCheapestETHPutOption;
    }

    /// @dev we could make another function that gets some options instead of only one
    /// @dev we could take fixed values for expiry and strike.
    /// @dev make this function into a view function somehow in the next version
    /// @param _minExpiry minimum expiration date in seconds from now
    /// @param _minStrikeInUSD minimum strike price in USD with 8 decimals
    /// @param _maxStrikeInUSD maximum strike price in USD with 8 decimals
    /// @param _optionSizeInWEI option size in WEI
    function getTheCheapestETHPutOption(
        uint256 _minExpiry,
        // uint256 _maxExpiry,
        uint256 _minStrikeInUSD,
        uint256 _maxStrikeInUSD,
        uint256 _optionSizeInWEI
    ) public view returns (TheCheapestETHPutOption memory) {
        // require expiry. check if it is agter the latest block time
        // expiry needs to be seconds from now in hegic and timestamp in opyn v1
        // but we don't use the expiry for the opyn for now. so it's seconds now

            TheCheapestETHPutOptionInHegicV888
                memory theCheapestETHPutOptionInHegicV888
         =
            getTheCheapestETHPutOptionInHegicV888(
                _minExpiry,
                _optionSizeInWEI,
                _minStrikeInUSD
            );
        require(
            hasEnoughETHLiquidityInHegicV888(_optionSizeInWEI) == true,
            "your size is too big for liquidity in the Hegic V888"
        );
        // the cheapest ETH put option across options protocols
        TheCheapestETHPutOption memory theCheapestETHPutOption =
            TheCheapestETHPutOption(
                Protocol.HegicV888,
                address(0), // NA
                address(0), // NA
                theCheapestETHPutOptionInHegicV888.expiry,
                _optionSizeInWEI,
                theCheapestETHPutOptionInHegicV888.premiumInWEI,
                theCheapestETHPutOptionInHegicV888.strikeInUSD
            );
        return theCheapestETHPutOption;
    }
}
