//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solady/utils/SSTORE2.sol";

/// @title  Library storage designed for large files
/// @notice forked from Library_v1_0 by xaltgeist, with code direction and consultation from 0x113d

// solhint-disable contract-name-camelcase
contract Support_Storage {

    /// @notice Names of available libraries (which are the keys for querying them)
    string[] public availableLibraries;

    /// @notice Mapping of library names to their data chunks
    mapping(string => address[]) private libraryToChunks;
    mapping(string => address) private libraryOwners;

    /// @notice The number of libraries available (i.e., the length of availableLibraries)
    uint public nLibraries;

    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     * LibraryOwner-Only Write Functions
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    /// @notice Write a chunk of text belonging to the key 'libraryName'
    /// @dev File chunks must be stored in order
    /// @param libraryName The name of the file to be stored
    /// @param chunk A chunk of the file to be stored
    function uploadChunk(string calldata libraryName, string calldata chunk) 
        external 
    {
        if(libraryToChunks[libraryName].length == 0) {
            availableLibraries.push(libraryName);
            nLibraries++;
            libraryOwners[libraryName] = msg.sender;
        } else {
            require(
                libraryOwners[libraryName] == msg.sender,
                "Only the library owner can upload chunks"
            );
        }

        libraryToChunks[libraryName].push(SSTORE2.write(bytes(chunk)));
    }

    /// @notice Write a chunk of text belonging to the key 'libraryName'
    /// @dev File chunks do not need to be stored in order, but index
    ///      must be <= the length of the existing array of data chunks
    /// @param libraryName The name of the file to be stored
    /// @param chunk A chunk of the file to be stored
    /// @param index The array index at which the chunk will be stored
    function uploadChunkAtIndex(
        string calldata libraryName, 
        string calldata chunk,
        uint index
    ) 
        external 
    {
        require(
            index <= libraryToChunks[libraryName].length,
            "Index out of range"
        );

        require(
            libraryOwners[libraryName] == msg.sender,
            "Only the library owner can upload chunks"
        );

        if (index == libraryToChunks[libraryName].length) {
            libraryToChunks[libraryName].push(SSTORE2.write(bytes(chunk)));
        } else {
            libraryToChunks[libraryName][index] = SSTORE2.write(bytes(chunk));
        }

        
    }

    /* * * * * * * * * * * * * * * * * * * * * 
     * Internal Helper Functions
     * * * * * * * * * * * * * * * * * * * * */

    function codeSize(address _addr) internal view returns (uint256 size) {
        assembly { size := extcodesize(_addr) }
    }

    /* * * * * * * * * * * * * * * * * * * * * 
     * Public Read Functions
     * * * * * * * * * * * * * * * * * * * * */
    /// @notice Retrieve a file
    /// @param libraryName The name of the file to be retrieved
    /// @return lib The library 
    function readLibrary(string calldata libraryName) 
        public 
        view 
        returns (string memory lib) 
    {
        // Retrieve the array of addresses containing the text chunks
        address[] storage chunks = libraryToChunks[libraryName];
        uint256 size;
        uint ptr = 0x20;
        address currentChunk;
        unchecked {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                lib := mload(0x40)
            }

            // Copy chunks from storage into memory
            for (uint i = 0; i < chunks.length; i++) {
                currentChunk = chunks[i];
                size = codeSize(currentChunk) - 1;

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    extcodecopy(currentChunk, add(lib, ptr), 1, size)
                }
                ptr += size;
            }

            // solhint-disable-next-line no-inline-assembly
            assembly {
                // allocate output byte array - this could also be done without assembly
                // by using o_code = new bytes(size)
                // new "memory end" including padding
                mstore(0x40, add(lib, and(add(ptr, 0x1f), not(0x1f))))
                // store length in memory
                mstore(lib, sub(ptr, 0x20))
            }
        }
        return lib;
    }
}