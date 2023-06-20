// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ExtERC721A } from "./ExtERC721A.sol";

import { ERC2981 } from "openzeppelin/token/common/ERC2981.sol";

import { UpdatableOperatorFilterer } from "operator-filter-registry/src/UpdatableOperatorFilterer.sol";
import { RevokableDefaultOperatorFilterer } from "operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol";

contract OFilterTemplate is ExtERC721A, ERC2981, RevokableDefaultOperatorFilterer {
    constructor(string memory _unrevealedURI) ExtERC721A("OFilterTemplate", "OFT", _unrevealedURI, 0, 777) {
        // 5% royalties for deployer
        _setDefaultRoyalty(msg.sender, 500);
    }

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

    function supportsInterface(bytes4 interfaceId) public view virtual override(ExtERC721A, ERC2981) returns (bool) {
        return ExtERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
    }

    //=========================================================================
    // ROYALTIES MANAGMENT
    //=========================================================================
    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function deleteDefaultRoyalty() external onlyOwner {
        _deleteDefaultRoyalty();
    }
}
