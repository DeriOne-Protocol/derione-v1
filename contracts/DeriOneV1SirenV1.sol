// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IMinterAmmSirenV1.sol";
import "./interfaces/IMarketSirenV1.sol";

contract DeriOneV1SirenV1 is Ownable {

    IMinterAmmSirenV1[] private minterAmmInstanceList;

    function _instantiateMinterAmm(address[] memory _minterAmmAddressList)
        private
    {
        for (uint256 i = 0; i < _minterAmmAddressList.length; i++) {
            minterAmmInstanceList.push(
                IMinterAmmSirenV1(_minterAmmAddressList[i])
            );
        }
    }
}
