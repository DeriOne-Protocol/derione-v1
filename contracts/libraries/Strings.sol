pragma solidity ^0.6.0;

/**
 * @author James Lockhart <james@n3tw0rk.co.uk>
 */
library Strings {
    /**
     * @param _base When being used for a data type this is the extended object otherwise this is the string to be measured
     */
    function length(string memory _base) internal pure returns (uint256) {
        bytes memory baseBytes = bytes(_base);
        return baseBytes.length;
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string starting
     * from a defined offset
     *
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param _value The needle to search for, at present this is currently
     *               limited to one character
     * @param _offset The starting point to start searching from which can start
     *                from 0, but must not exceed the length of the string
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function _indexOf(
        string memory _base,
        string memory _value,
        uint256 _offset
    ) internal pure returns (int256) {
        bytes memory baseBytes = bytes(_base);
        bytes memory valueBytes = bytes(_value);

        assert(valueBytes.length == 1);

        for (uint256 i = _offset; i < baseBytes.length; i++) {
            if (baseBytes[i] == valueBytes[0]) {
                return int256(i);
            }
        }

        return -1;
    }

    /**
     * String Split (Very high gas cost)
     *
     * Splits a string into an array of strings based off the delimiter value.
     * Please note this can be quite a gas expensive function due to the use of
     * storage so only use if really required.
     *
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string value to be split.
     * @param _value The delimiter to split the string on which must be a single
     *               character
     */
    function split(string memory _base, string memory _value)
        internal
        pure
        returns (string[] memory splitArr)
    {
        bytes memory baseBytes = bytes(_base);

        uint256 offset = 0;
        uint256 splitsCount = 1;
        while (offset < baseBytes.length - 1) {
            int256 limit = _indexOf(_base, _value, offset);
            if (limit == -1) break;
            else {
                splitsCount++;
                offset = uint256(limit) + 1;
            }
        }

        splitArr = new string[](splitsCount);

        offset = 0;
        splitsCount = 0;
        while (offset < baseBytes.length - 1) {
            int256 limit = _indexOf(_base, _value, offset);
            if (limit == -1) {
                limit = int256(baseBytes.length);
            }

            string memory tmp = new string(uint256(limit) - offset);
            bytes memory tmpBytes = bytes(tmp);

            uint256 j = 0;
            for (uint256 i = offset; i < uint256(limit); i++) {
                tmpBytes[j++] = baseBytes[i];
            }
            offset = uint256(limit) + 1;
            splitArr[splitsCount++] = string(tmpBytes);
        }
        return splitArr;
    }
}
