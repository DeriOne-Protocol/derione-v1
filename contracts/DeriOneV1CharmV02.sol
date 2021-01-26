// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ICharmV02OptionFactory.sol";
import "./libraries/DataTypes.sol";

contract DeriOneV1CharmV02 is Ownable {
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
}
