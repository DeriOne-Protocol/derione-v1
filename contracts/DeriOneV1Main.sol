// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./DeriOneV1HegicV888.sol";
import "./DeriOneV1OpynV1.sol";

/// @author tai
/// @title A contract for getting the cheapest options price
/// @notice For now, this contract gets the cheapest ETH/WETH put options price from Opyn V1 and Hegic V888
/// @dev explicitly state the data location for all variables of struct, array or mapping types (including function parameters)
/// @dev adjust visibility of variables. they should be all private by default i guess
contract DeriOneV1Main is DeriOneV1HegicV888, DeriOneV1OpynV1 {
    enum Protocol {HegicV888, OpynV1}
    struct TheCheapestETHPutOption {
        Protocol protocol;
        address oTokenAddress;
        address paymentTokenAddress;
        uint256 expiry;
        uint256 optionSizeInWEI;
        uint256 premiumInWEI;
        uint256 strikeInUSD;
    }

    // the cheapest ETH put option across options protocols
    TheCheapestETHPutOption private _theCheapestETHPutOption;

    event TheCheapestETHPutOptionGot(string protocolName);
    event ETHPutOptionBought(string protocolName);

    constructor(
        address _ETHPriceOracleAddress,
        address _hegicETHOptionV888Address,
        address _hegicETHPoolV888Address,
        address _opynExchangeV1Address,
        address _opynOptionsFactoryV1Address,
        address _uniswapFactoryV1Address
    )
        public
        DeriOneV1HegicV888(
            _ETHPriceOracleAddress,
            _hegicETHOptionV888Address,
            _hegicETHPoolV888Address
        )
        DeriOneV1OpynV1(
            _opynExchangeV1Address,
            _opynOptionsFactoryV1Address,
            _uniswapFactoryV1Address
        )
    {}

    function theCheapestETHPutOption() public view returns (TheCheapestETHPutOption memory) {
        return _theCheapestETHPutOption;
    }

    /// @dev what is decimal place of usd value?
    /// @dev we could make another function that gets some options instead of only one
    /// @dev we could take fixed values for expiry and strike.
    /// @dev this function changes the state. you need to change the state just to get the cheapest option.
    /// @dev make functions that need to change the state that can be called by owner or everybody so that the cheapest options can be obtained with a view function
    function getTheCheapestETHPutOption(
        uint256 _minExpiry,
        // uint256 _maxExpiry,
        uint256 _minStrikeInUSD,
        uint256 _maxStrikeInUSD,
        uint256 _optionSizeInWEI
    ) public returns (TheCheapestETHPutOption memory) {
        getTheCheapestETHPutOptionInHegicV888(_minExpiry, _minStrikeInUSD);
        require(
            hasEnoughETHLiquidityInHegicV888(_optionSizeInWEI) == true,
            "your size is too big for liquidity in the Hegic V888"
        );
        getTheCheapestETHPutOptionInOpynV1(
            // _minExpiry,
            // _maxExpiry,
            _minStrikeInUSD,
            _maxStrikeInUSD,
            _optionSizeInWEI
        );
        require(
            hasEnoughOTokenLiquidityInOpynV1(_optionSizeInWEI) == true,
            "your size is too big for this oToken liquidity in the Opyn V1"
        );
        if (
            theCheapestETHPutOptionInHegicV888.premiumInWEI <
            theCheapestWETHPutOptionInOpynV1.premiumInWEI
        ) {
            _theCheapestETHPutOption = TheCheapestETHPutOption(
                Protocol.HegicV888,
                address(0),
                address(0),
                theCheapestETHPutOptionInHegicV888.expiry,
                0,
                theCheapestETHPutOptionInHegicV888.premiumInWEI,
                theCheapestETHPutOptionInHegicV888.strikeInUSD
            );
            emit TheCheapestETHPutOptionGot("hegic v888");
            return _theCheapestETHPutOption;
        } else if (
            theCheapestETHPutOptionInHegicV888.premiumInWEI >
            theCheapestWETHPutOptionInOpynV1.premiumInWEI
        ) {
            _theCheapestETHPutOption = TheCheapestETHPutOption(
                Protocol.OpynV1,
                theCheapestWETHPutOptionInOpynV1.oTokenAddress,
                address(0),
                theCheapestWETHPutOptionInOpynV1.expiry,
                0,
                theCheapestWETHPutOptionInOpynV1.premiumInWEI,
                theCheapestWETHPutOptionInOpynV1.strikeInUSD
            );
            emit TheCheapestETHPutOptionGot("opyn v1");
            return _theCheapestETHPutOption;
        } else {
            emit TheCheapestETHPutOptionGot("no matches");
        }
    }

    function buyTheCheapestETHPutOption(
        uint256 _minExpiry,
        // uint256 _maxExpiry,
        uint256 _minStrikeInUSD,
        uint256 _maxStrikeInUSD,
        uint256 _optionSizeInWEI,
        address _receiver
    ) public {
        getTheCheapestETHPutOption(
            _minExpiry,
            // _maxExpiry,
            _minStrikeInUSD,
            _maxStrikeInUSD,
            _optionSizeInWEI
        );
        if (_theCheapestETHPutOption.protocol == Protocol.HegicV888) {
            buyETHPutOptionInHegicV888(
                _theCheapestETHPutOption.expiry,
                _theCheapestETHPutOption.optionSizeInWEI,
                _theCheapestETHPutOption.strikeInUSD
            );
            emit ETHPutOptionBought("Hegic v888");
        } else if (_theCheapestETHPutOption.protocol == Protocol.OpynV1) {
            buyETHPutOptionInOpynV1(
                _receiver,
                _theCheapestETHPutOption.oTokenAddress,
                _theCheapestETHPutOption.paymentTokenAddress,
                _theCheapestETHPutOption.optionSizeInWEI
            );
            emit ETHPutOptionBought("opyn v1");
        } else {
            emit ETHPutOptionBought("no match");
        }
    }
}
