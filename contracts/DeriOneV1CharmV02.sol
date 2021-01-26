// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ICharmV02OptionFactory.sol";

contract DeriOneV1CharmV02 is Ownable {
    ICharmV02OptionFactory private CharmV02OptionFactoryInstance;

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
}
