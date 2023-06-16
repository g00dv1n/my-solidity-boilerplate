// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ExtERC721A } from "./ExtERC721A.sol";

import { UpdatableOperatorFilterer } from "operator-filter-registry/src/UpdatableOperatorFilterer.sol";
import { RevokableDefaultOperatorFilterer } from "operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol";

contract OFilterTemplate is ExtERC721A, RevokableDefaultOperatorFilterer {
    constructor(string memory _unrevealedURI) ExtERC721A("OFilterTemplate", "OFT", _unrevealedURI, 0, 100) { }

    //=========================================================================
    // DEFAULT OVERRIDES FOR OPERATOR FILTER
    //=========================================================================

    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    )
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    )
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    )
        public
        payable
        override
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function owner() public view override(ExtERC721A, UpdatableOperatorFilterer) returns (address) {
        return ExtERC721A.owner();
    }
}
