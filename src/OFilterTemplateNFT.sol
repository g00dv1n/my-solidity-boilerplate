// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { BatchMintNFT } from "./BatchMintNFT.sol";

import { UpdatableOperatorFilterer } from "operator-filter-registry/src/UpdatableOperatorFilterer.sol";
import { RevokableDefaultOperatorFilterer } from "operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol";

contract OFilterTemplateNFT is BatchMintNFT, RevokableDefaultOperatorFilterer {
    constructor(string memory _unrevealedURI) BatchMintNFT("OFilterTemplateNFT", "OFT", _unrevealedURI, 1 gwei, 100) { }

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

    function owner() public view override(BatchMintNFT, UpdatableOperatorFilterer) returns (address) {
        return BatchMintNFT.owner();
    }
}
