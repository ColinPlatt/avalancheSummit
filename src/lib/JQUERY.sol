//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import './Utils.sol';

// Core jQuery utility library which helps us construct
// onchain jQuery scripts with a simple, web-like API.
library jQuery {

    /* MAIN ELEMENTS */
    function cdn()
        internal
        pure
        returns (string memory)
    {
        return '<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>';
    }

    function cdn(string memory _version)
        internal
        pure
        returns (string memory)
    {
        return string.concat(
            '<script src="https://code.jquery.com/jquery-',
            _version,
            '.min.js"></script>'
        );
    }

    function alert(string memory _msg)
        internal
        pure
        returns (string memory)
    {
        return string.concat(
            'alert(',
            _msg,
            ');'
        );
    }

    /* AJAX */
    function ajax(string memory _url, string memory _type, string memory _dataType, string memory _data) internal pure returns (string memory) {
        return string.concat(
            '$.ajax({',
            'url:"', _url, '",',
            'type:"', _type, '",',
            'dataType:"', _dataType, '",',
            'data:', _data,
            '});'
        );
    }

    function get(string memory _url, string memory _callback) internal pure returns (string memory) {
        return string.concat(
            '$.get(',
            _url,
            ',',
            _callback,
            ')'
        );
    }

    function post(string memory _url, string memory _data, string memory _callback) internal pure returns (string memory) {
        return string.concat(
            '$.post(',
            _url,
            ',',
            _data,
            ',',
            _callback,
            ')'
        );
    }

    function getJSON(string memory _url, string memory _callback) internal pure returns (string memory) {
        return string.concat(
            '$.getJSON(',
            _url,
            ',',
            _callback,
            ')'
        );
    }

    function getScript(string memory _url, string memory _callback) internal pure returns (string memory) {
        return string.concat(
            '$.getScript(',
            _url,
            ',',
            _callback,
            ')'
        );
    }

    /* EVENT HANDLERS */
    function onClick(string memory _selector, string memory function_Body) internal pure returns (string memory) {
        return query(_selector, "click", function_(function_Body));
    }

    function onKeyUp(string memory _selector, string memory function_Body) internal pure returns (string memory) {
        return query(_selector, "keyup", function_(function_Body));
    }

    function onKeyDown(string memory _selector, string memory function_Body) internal pure returns (string memory) {
        return query(_selector, "keydown", function_(function_Body));
    }

    /* CSS MANIPULATION */
    function addClass(string memory _selector, string memory _className) internal pure returns (string memory) {
        return query(_selector, "addClass", _className);
    }

    function removeClass(string memory _selector, string memory _className) internal pure returns (string memory) {
        return query(_selector, "removeClass", _className);
    }

    function toggleClass(string memory _selector, string memory _className) internal pure returns (string memory) {
        return query(_selector, "toggleClass", _className);
    }

    function css(string memory _selector, string memory _property, string memory _value) internal pure returns (string memory) {
        return query(_selector, "css", string.concat(_property, ':', _value));
    }

    /* DOM MANIPULATION */
    function append(string memory _selector, string memory _content) internal pure returns (string memory) {
        return query(_selector, "append", _content);
    }

    function prepend(string memory _selector, string memory _content) internal pure returns (string memory) {
        return query(_selector, "prepend", _content);
    }

    function after_(string memory _selector, string memory _content) internal pure returns (string memory) {
        return query(_selector, "after", _content);
    }

    function before(string memory _selector, string memory _content) internal pure returns (string memory) {
        return query(_selector, "before", _content);
    }

    /* ANIMATION */
    function fadeIn(string memory _selector) internal pure returns (string memory) {
        return query(_selector, "fadeIn");
    }

    function fadeOut(string memory _selector) internal pure returns (string memory) {
        return query(_selector, "fadeOut");
    }

    function slideUp(string memory _selector) internal pure returns (string memory) {
        return query(_selector, "slideUp");
    }

    function slideDown(string memory _selector) internal pure returns (string memory) {
        return query(_selector, "slideDown");
    }




    /* COMMON */
    function query(string memory _child) internal pure returns (string memory) {
        return string.concat(
            '$(',
            _child,
            ');'
        );
    }

    function query(string memory _selector, string memory _action) internal pure returns (string memory) {
        return string.concat(
            '$("',
            _selector,
            '").',
            _action,
            '();'
        );
    }

    function query(string memory _selector, string memory _action, string memory _child) internal pure returns (string memory) {
        return string.concat(
            '$("',
            _selector,
            '").',
            _action,
            '(',
            _child,
            ');'
        );
    }

    function query(string memory _selector, string[] memory _actions, string[] memory _children) internal pure returns (string memory) {
        string memory chainedQueries;

        unchecked {
            for(uint i = 0; i< _actions.length; ++i) {
                chainedQueries = string.concat(
                    chainedQueries,
                    '.',
                    _actions[i],
                    '(',
                    _children[i],
                    ')'
                );
            }
        }
        
        return string.concat(
            '$("',
            _selector,
            '")',
            chainedQueries,
            ';'
        );
    }

    function this_(string memory _action) internal pure returns (string memory) {
        return string.concat(
            '$(this).',
            _action,
            '()'
        );
    }

    function this_(string memory _action, string memory _child) internal pure returns (string memory) {
        return string.concat(
            '$(this).',
            _action,
            '(',
            _child,
            ')'
        );
    }

    function function_(string memory _child) internal pure returns (string memory) {
        return string.concat(
            'function(){',
            _child,
            '}'
        );
    }

    function function_(string memory _params, string memory _child) internal pure returns (string memory) {
        return string.concat(
            'function(',
            _params,
            '){',
            _child,
            '}'
        );
    }

    function asyncFunction_(string memory _child) internal pure returns (string memory) {
        return string.concat(
            'async(){',
            _child,
            '}'
        );
    }

    function asyncFunction_(string memory _params, string memory _child) internal pure returns (string memory) {
        return string.concat(
            'async(',
            _params,
            '){',
            _child,
            '}'
        );
    }

    function params(string memory _child) internal pure returns (string memory) {
        return string.concat(
            '{',
            _child,
            '}'
        );
    }

    function param(string memory _key, string memory _value) internal pure returns (string memory) {
        return string.concat(
            _key,
            ':',
            _value,
            ','
        );
    }

    function paramLast(string memory _key, string memory _value) internal pure returns (string memory) {
        return string.concat(
            _key,
            ':',
            _value
        );
    }


}