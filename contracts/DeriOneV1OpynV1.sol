// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IOpynExchangeV1.sol";
import "./interfaces/IOpynOptionsFactoryV1.sol";
import "./interfaces/IOpynOTokenV1.sol";
import "./interfaces/IUniswapExchangeV1.sol";
import "./interfaces/IUniswapFactoryV1.sol";

contract DeriOneV1OpynV1 is Ownable {
    using SafeMath for uint256;

    IOpynExchangeV1 private OpynExchangeV1Instance;
    IOpynOptionsFactoryV1 private OpynOptionsFactoryV1Instance;
    IOpynOTokenV1[] private oTokenV1InstanceList;
    IOpynOTokenV1[] private WETHPutOptionOTokenV1InstanceList;
    IOpynOTokenV1[] private matchedWETHPutOptionOTokenV1InstanceList;
    IUniswapExchangeV1 private UniswapExchangeV1Instance;
    IUniswapFactoryV1 private UniswapFactoryV1Instance;

    address constant USDCTokenAddress =
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant WETHTokenAddress =
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address[] private oTokenAddressList;
    address[] private unexpiredOTokenAddressList;
    address[] private matchedWETHPutOptionOTokenAddressList;

    struct MatchedWETHPutOptionOTokenV1 {
        address oTokenAddress;
        uint256 expiry;
        uint256 premiumInWEI;
        uint256 strikeInUSD; // scaled by 10 ** 7 for the USDC denominator
        // strictly speaking, it's possible that 10 ** 7 can be too small or big depending on the value passed to the `_strikePrice` and `_strikeExp` of the factory contract at the point of a new oToken contract creation. they want to get decimals from the USDC token contract and programmatically pass it.
    }

    struct TheCheapestWETHPutOptionInOpynV1 {
        address oTokenAddress;
        uint256 expiry;
        uint256 premiumInWEI;
        uint256 strikeInUSD; // scaled by 10 ** 7 for the USDC denominator
        // strictly speaking, it's possible that 10 ** 7 can be too small or big depending on the value passed to the `_strikePrice` and `_strikeExp` of the factory contract at the point of a new oToken contract creation.
    }

    // a matched oToken list with a buyer's expiry and strike price conditions
    MatchedWETHPutOptionOTokenV1[] matchedWETHPutOptionOTokenListV1;
    // could be mapping(address => MatchedWETHPutOptionOTokenV1) matchedWETHPutOptionOTokenListV1;

    // the cheaptest WETH put option in the Opyn V1
    TheCheapestWETHPutOptionInOpynV1 theCheapestWETHPutOptionInOpynV1;

    // could be mapping(address => TheCheapestWETHPutOptionInOpynV1) theCheapestWETHPutOptionInOpynV1;

    constructor(
        address _opynExchangeV1Address,
        address _opynOptionsFactoryV1Address,
        address _uniswapFactoryV1Address
    ) public {
        instantiateOpynExchangeV1(_opynExchangeV1Address);
        instantiateOpynOptionsFactoryV1(_opynOptionsFactoryV1Address);
        instantiateUniswapFactoryV1(_uniswapFactoryV1Address);
    }

    /// @param _opynExchangeV1Address OpynExchangeV1Address
    function instantiateOpynExchangeV1(address _opynExchangeV1Address)
        public
        onlyOwner
    {
        OpynExchangeV1Instance = IOpynExchangeV1(_opynExchangeV1Address);
    }

    /// @param _opynOptionsFactoryV1Address OpynOptionsFactoryV1Address
    function instantiateOpynOptionsFactoryV1(
        address _opynOptionsFactoryV1Address
    ) public onlyOwner {
        OpynOptionsFactoryV1Instance = IOpynOptionsFactoryV1(
            _opynOptionsFactoryV1Address
        );
    }

    /// @param _uniswapFactoryV1Address UniswapFactoryV1Address
    function instantiateUniswapFactoryV1(address _uniswapFactoryV1Address)
        public
        onlyOwner
    {
        UniswapFactoryV1Instance = IUniswapFactoryV1(_uniswapFactoryV1Address);
    }

    /// @param _opynOTokenV1AddressList OpynOTokenV1Address
    /// @dev this needs to be called not only in a constructor because new contracts will be created
    function _instantiateOpynOTokenV1(address[] memory _opynOTokenV1AddressList)
        private
    {
        for (uint256 i = 0; i < _opynOTokenV1AddressList.length; i++) {
            oTokenV1InstanceList.push(
                IOpynOTokenV1(_opynOTokenV1AddressList[i])
            );
        }
    }

    /// @param _uniswapExchangeV1Address UniswapExchangeV1Address
    function _instantiateUniswapExchangeV1(address _uniswapExchangeV1Address)
        private
    {
        UniswapExchangeV1Instance = IUniswapExchangeV1(
            _uniswapExchangeV1Address
        );
    }

    /// @notice get the list of WETH put option oToken addresses
    /// @dev in the Opyn V1, there are only put options and thus no need to filter a type
    /// @dev we don't use ETH put options because the Opyn V1 has vulnerability there
    function _getWETHPutOptionsOTokenAddressList() private {
        uint256 theNumberOfOTokenAddresses =
            OpynOptionsFactoryV1Instance.getNumberOfOptionsContracts();
        for (uint256 i = 0; i < theNumberOfOTokenAddresses; i++) {
            oTokenAddressList.push(
                OpynOptionsFactoryV1Instance.optionsContracts(i)
            );
        }
        _instantiateOpynOTokenV1(oTokenAddressList);
        for (uint256 i = 0; i < oTokenV1InstanceList.length; i++) {
            if (
                oTokenV1InstanceList[i].underlying() == WETHTokenAddress &&
                oTokenV1InstanceList[i].strike() == USDCTokenAddress //the asset in which the insurance is calculated
                // oTokenV1InstanceList[i].expiry() > block.timestamp // I am commenting out expiry condition because there is nothing that matches this condition. this is because of a combination of the hacking and their upcoming v2
            ) {
                WETHPutOptionOTokenV1InstanceList.push(oTokenV1InstanceList[i]);
                unexpiredOTokenAddressList.push(oTokenAddressList[i]);
            }
        }
    }

    /// @dev strike price is scaled by 10 ** 7 for the USDC denominator
    function _calculateStrike(IOpynOTokenV1 _oTokenV1Instance)
        private
        view
        returns (uint256)
    {
        uint256 strike;
        (uint256 value, int32 exponent) = _oTokenV1Instance.strikePrice();
        if (exponent >= 0) {
            strike = value.mul(uint256(10)**uint256(exponent)).mul(10**7);
        } else {
            strike = value.mul(
                uint256(1).mul(10**7).div(10**uint256(0 - exponent))
            );
        }
        return strike;
    }

    /// @notice get WETH Put Options that meet expiry and strike conditions
    // / @param _minExpiry minimum expiration date
    // / @param _maxExpiry maximum expiration date
    /// @param _minStrikeInUSD minimum strike price
    /// @param _maxStrikeInUSD maximum strike price
    function _filterWETHPutOptionsOTokenAddresses(
        // uint256 _minExpiry,
        // uint256 _maxExpiry,
        uint256 _minStrikeInUSD,
        uint256 _maxStrikeInUSD
    ) private {
        for (uint256 i = 0; i < WETHPutOptionOTokenV1InstanceList.length; i++) {
            uint256 strike =
                _calculateStrike(WETHPutOptionOTokenV1InstanceList[i]);
            if (
                _minStrikeInUSD < strike && strike < _maxStrikeInUSD
                // _minExpiry < WETHPutOptionOTokenV1InstanceList[i].expiry() &&
                // WETHPutOptionOTokenV1InstanceList[i].expiry() < _maxExpiry // I am commenting out expiry condition because there is nothing that matches this condition. this is because of a combination of the hacking and their upcoming v2
            ) {
                matchedWETHPutOptionOTokenV1InstanceList.push(
                    WETHPutOptionOTokenV1InstanceList[i]
                );
                matchedWETHPutOptionOTokenAddressList.push(
                    unexpiredOTokenAddressList[i]
                );
            }
        }
    }

    /// @param _expiry expiration date
    /// @param _strike strike price
    /// @param _oTokensToBuy the amount of oToken to buy
    function _getOpynV1Premium(
        uint256 _expiry,
        uint256 _strike,
        uint256 _oTokensToBuy
    ) private view returns (uint256) {
        address oTokenAddress;
        for (
            uint256 i = 0;
            i < matchedWETHPutOptionOTokenV1InstanceList.length;
            i++
        ) {
            uint256 strikePrice =
                _calculateStrike(matchedWETHPutOptionOTokenV1InstanceList[i]);

            if (
                matchedWETHPutOptionOTokenV1InstanceList[i].expiry() ==
                _expiry &&
                strikePrice == _strike
            ) {
                oTokenAddress = matchedWETHPutOptionOTokenListV1[i]
                    .oTokenAddress;
            }
        }
        uint256 premiumToPayInWEI =
            OpynExchangeV1Instance.premiumToPay(
                oTokenAddress,
                address(0), // pay with ETH
                _oTokensToBuy
            );
        return premiumToPayInWEI;
    }

    /// @param _optionSizeInWEI the size of an option to buy in WEI
    function _constructMatchedWETHPutOptionOTokenListV1(
        uint256 _optionSizeInWEI
    ) private {
        for (
            uint256 i = 0;
            i < matchedWETHPutOptionOTokenV1InstanceList.length;
            i++
        ) {
            uint256 strikePrice =
                _calculateStrike(matchedWETHPutOptionOTokenV1InstanceList[i]);
            address uniswapExchangeContractAddress =
                UniswapFactoryV1Instance.getExchange(
                    matchedWETHPutOptionOTokenAddressList[i]
                );
            _instantiateUniswapExchangeV1(uniswapExchangeContractAddress);
            uint256 oTokensToBuy =
                UniswapExchangeV1Instance.getEthToTokenInputPrice(
                    _optionSizeInWEI
                );

            matchedWETHPutOptionOTokenListV1[i] = MatchedWETHPutOptionOTokenV1(
                matchedWETHPutOptionOTokenAddressList[i],
                matchedWETHPutOptionOTokenV1InstanceList[i].expiry(),
                _getOpynV1Premium(
                    matchedWETHPutOptionOTokenV1InstanceList[i].expiry(),
                    strikePrice,
                    oTokensToBuy
                ),
                strikePrice
            );
        }
    }

    /// @param _optionSizeInWEI the size of an option to buy in WEI
    /// @dev write a function for power operations. it might overflow? the SafeMath library doesn't support this yet.
    /// @dev oTokenExchangeRate is scaled by 10**9 because it can be a floating number
    function hasEnoughOTokenLiquidityInOpynV1(uint256 _optionSizeInWEI)
        internal
        returns (bool)
    {
        address uniswapExchangeContractAddress =
            UniswapFactoryV1Instance.getExchange(
                theCheapestWETHPutOptionInOpynV1.oTokenAddress
            );
        IOpynOTokenV1 theCheapestOTokenV1Instance =
            IOpynOTokenV1(theCheapestWETHPutOptionInOpynV1.oTokenAddress);
        uint256 oTokenLiquidity =
            theCheapestOTokenV1Instance.balanceOf(
                uniswapExchangeContractAddress
            );

        uint256 oTokenExchangeRate;
        (uint256 value, int32 exponent) =
            theCheapestOTokenV1Instance.oTokenExchangeRate();
        if (exponent >= 0) {
            oTokenExchangeRate = value.mul(uint256(10)**uint256(exponent)).mul(
                10**9
            );
        } else {
            oTokenExchangeRate = value
                .mul(uint256(1).div(10**uint256(0 - exponent)))
                .mul(10**9);
        }
        uint256 optionSizeInOToken = _optionSizeInWEI.mul(oTokenExchangeRate);

        oTokenLiquidity.mul(10**9);

        if (optionSizeInOToken < oTokenLiquidity) {
            return true;
        } else {
            return false;
        }
    }

    function getTheCheapestETHPutOptionInOpynV1(
        // uint256 _minExpiry,
        // uint256 _maxExpiry,
        uint256 _minStrikeInUSD,
        uint256 _maxStrikeInUSD,
        uint256 _optionSizeInWEI
    ) internal {
        _getWETHPutOptionsOTokenAddressList();
        _filterWETHPutOptionsOTokenAddresses(
            // _minExpiry,
            // _maxExpiry,
            _minStrikeInUSD,
            _maxStrikeInUSD
        );
        _constructMatchedWETHPutOptionOTokenListV1(_optionSizeInWEI);
        uint256 minimumPremium =
            matchedWETHPutOptionOTokenListV1[0].premiumInWEI;
        for (uint256 i = 0; i < matchedWETHPutOptionOTokenListV1.length; i++) {
            if (
                matchedWETHPutOptionOTokenListV1[i].premiumInWEI >
                matchedWETHPutOptionOTokenListV1[i + 1].premiumInWEI
            ) {
                minimumPremium = matchedWETHPutOptionOTokenListV1[i + 1]
                    .premiumInWEI;
            }
        }

        for (uint256 i = 0; i < matchedWETHPutOptionOTokenListV1.length; i++) {
            if (
                minimumPremium ==
                matchedWETHPutOptionOTokenListV1[i].premiumInWEI
            ) {
                theCheapestWETHPutOptionInOpynV1 = TheCheapestWETHPutOptionInOpynV1(
                    matchedWETHPutOptionOTokenAddressList[i],
                    matchedWETHPutOptionOTokenListV1[i].expiry,
                    minimumPremium,
                    matchedWETHPutOptionOTokenListV1[i].strikeInUSD
                );
            }
        }
    }

    /// @param _receiver the account that will receive the oTokens
    /// @param _oTokenAddress the address of the oToken that is being bought
    /// @param _paymentTokenAddress the address of the token you are paying for oTokens with
    /// @param _oTokensToBuy the number of oTokens to buy
    function buyETHPutOptionInOpynV1(
        address _receiver,
        address _oTokenAddress,
        address _paymentTokenAddress,
        uint256 _oTokensToBuy
    ) internal {
        // can i pass some values from storage variables?
        OpynExchangeV1Instance.buyOTokens(
            _receiver,
            _oTokenAddress,
            _paymentTokenAddress,
            _oTokensToBuy
        );
    }
}

// this contract consumes too much gas just to get the cheapest option
