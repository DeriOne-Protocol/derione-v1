// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IMinterAmmSirenV1.sol";
import "./interfaces/IMarketSirenV1.sol";

contract DeriOneV1SirenV1 is Ownable {

    address[] private marketAddressList;
    IMinterAmmSirenV1[] private minterAmmInstanceList;
    IMarketSirenV1[] private marketInstanceList;

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
            for (uint256 i = 0; i < markets.length; i++) {
                marketAddressList.push();
            }
        }
    }

    function _instantiateMarket(address[] memory _marketAddressList) private {
        for (uint256 i = 0; i < _marketAddressList.length; i++) {
            marketInstanceList.push(IMarketSirenV1(_marketAddressList[i]));
        }
    }
}
