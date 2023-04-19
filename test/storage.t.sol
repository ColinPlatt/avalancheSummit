// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Support_Storage.sol";

contract storageTest is Test {

    Support_Storage storageContract;
    string[20] public ethers_chunks;
    string public constant ethers_libraryName = "ethers 0.6.23";

    string[4] public jquery_chunks;
    string public constant jquery_libraryName = "jquery 3.6.4";

    string[11] public jquery_ui_chunks;
    string public constant jquery_ui_libraryName = "jquery-ui 1.13.2";

    function setUp() public {
        storageContract = new Support_Storage();
    }

    function _loadChunks() internal {
        unchecked {
            for (uint256 i = 0; i < 20; i++) {
                ethers_chunks[i] = vm.readFile(string.concat('test/data/chunks/ethers_', vm.toString(i)));
            }

            for (uint256 i = 0; i < 4; i++) {
                jquery_chunks[i] = vm.readFile(string.concat('test/data/chunks/jquery_', vm.toString(i)));
            }

            for (uint256 i = 0; i < 11; i++) {
                jquery_ui_chunks[i] = vm.readFile(string.concat('test/data/chunks/jquery_ui_', vm.toString(i)));
            }
        }
    }

    function testChunks() public {
        _loadChunks();
        string memory fullFile_ethers = vm.readFile('test/data/ethers.txt');
        string memory testCompile_ethers;
        unchecked {
            for (uint256 i = 0; i < 20; i++) {
                testCompile_ethers = string.concat(testCompile_ethers, ethers_chunks[i]);
            }
        }
        assertEq(testCompile_ethers, fullFile_ethers, "ethers: testCompile should equal fullFile");

        string memory fullFile_jquery = vm.readFile('test/data/jquery.txt');
        string memory testCompile_jquery;

        unchecked {
            for (uint256 i = 0; i < 4; i++) {
                testCompile_jquery = string.concat(testCompile_jquery, jquery_chunks[i]);
            }
        }
        assertEq(testCompile_jquery, fullFile_jquery, "jq: testCompile should equal fullFile");

        string memory fullFile_jquery_ui = vm.readFile('test/data/jquery-ui.txt');
        string memory testCompile_jquery_ui;
        
        unchecked {
            for (uint256 i = 0; i < 11; i++) {
                testCompile_jquery_ui = string.concat(testCompile_jquery_ui, jquery_ui_chunks[i]);
            }
        }
        assertEq(testCompile_jquery_ui, fullFile_jquery_ui, "jq_ui: testCompile should equal fullFile");
    }   

    function testLoadStorage() public {
        string memory fullFile_ethers = vm.readFile('test/data/ethers.txt');
        string memory fullFile_jquery = vm.readFile('test/data/jquery.txt');
        string memory fullFile_jquery_ui = vm.readFile('test/data/jquery-ui.txt');

        unchecked {
            for (uint256 i = 0; i < 20; i++) {
                storageContract.uploadChunk(ethers_libraryName, vm.readFile(string.concat('test/data/chunks/ethers_', vm.toString(i))));
            }
            for (uint256 i = 0; i < 4; i++) {
                storageContract.uploadChunk(jquery_libraryName, vm.readFile(string.concat('test/data/chunks/jquery_', vm.toString(i))));
            }
            for (uint256 i = 0; i < 11; i++) {
                storageContract.uploadChunk(jquery_ui_libraryName, vm.readFile(string.concat('test/data/chunks/jquery_ui_', vm.toString(i))));
            }
        }
        assertEq(storageContract.readLibrary(ethers_libraryName), fullFile_ethers, "ethers: readLibrary should equal fullFile");
        assertEq(storageContract.readLibrary(jquery_libraryName), fullFile_jquery, "jq: readLibrary should equal fullFile");
        assertEq(storageContract.readLibrary(jquery_ui_libraryName), fullFile_jquery_ui, "jq_ui: readLibrary should equal fullFile");
    }

}