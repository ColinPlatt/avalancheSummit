// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.17;

import {ERC721} from "solmate/tokens/ERC721.sol";


contract AvalancheSummitPresentation is ERC721("Avalanche Summit II Presentation", "AVA2") {
    
    constructor() {
        mintCopy();
    }

    uint256 totalSupply;

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "s";
    }

    function mintCopy() public {
        _mint(msg.sender, totalSupply);
        totalSupply++;
    }

}
