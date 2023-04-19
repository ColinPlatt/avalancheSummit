// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.17;

import "./Support_Storage.sol";

import {HTML, utils} from "./lib/HTML.sol"; 

contract Slides {
    using HTML for string;
    using utils for *;

    Support_Storage public immutable storageCt;

    constructor() {
        storageCt = new Support_Storage();
    }

    function _bodyStyle() internal pure returns (string memory) {
        return HTML.cssSelector(
            'body', 
            string.concat(
                HTML.cssDecl('margin', '0'),
                HTML.cssDecl('font-family', 'Inter, sans-serif'),
                HTML.cssDecl('background-color', '#fff'),
                HTML.cssDecl('overflow', 'hidden')
            )
        );
    }

    function _slideStyle() internal pure returns (string memory) {
        return string.concat(
            HTML.cssSelector(
                '.slide', 
                'position: absolute;top: 0;left: 0;width: 100%;height: 100%;display: flex;flex-direction: column;justify-content: center;align-items: center;font-size: 48px;color: white;padding: 20px;box-sizing: border-box;overflow: auto;'
            ),
            HTML.cssSelector(
                '#titleSlide', 
                'background-color: #e84142ff;'
            )
        );
    }

    function _style() internal pure returns (string memory) {
        return string.concat(
            _bodyStyle(),
            _slideStyle()
        ).style();
    }

    function _scripts() internal view returns (string memory) {
        
    }

    function _head() internal view returns (string memory) {
        return string.concat(
            '<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Avalanche Summit II - Onchain Metadata</title>',
            _style(),
            _scripts(),
            '</head>'
        );
    }

    function _body() internal view returns (string memory) {
        
    }

    function renderPresentation() public view returns (string memory) {
        return string.concat(
            _head(),
            _body()
        ).html();
    }



}