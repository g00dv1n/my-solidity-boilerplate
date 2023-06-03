// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { Owned } from "./mixins/Owned.sol";
import { Defaults } from "./mixins/Defaults.sol";
import { Withdraw } from "./mixins/Withdraw.sol";

contract BaseERC721A is ERC721A, Owned, Defaults, Withdraw {
    string public baseURI;
    string public unrevealedURI;

    uint256 public immutable maxSupply;
    uint256 public mintPrice;

    error MintPriceNotPaid();
    error MaxSupply();
    error MintZero();
    error MaxMintPerTx();

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _unrevealedURI,
        uint256 _mintPrice,
        uint256 _maxSupply
    )
        ERC721A(_name, _symbol)
        Owned(msg.sender)
    {
        // set placeholder URI that will be using till reveal
        unrevealedURI = _unrevealedURI;

        // set up supply and pricing
        mintPrice = _mintPrice;
        maxSupply = _maxSupply;
    }

    //=========================================================================
    // Mint
    //=========================================================================
    modifier supplyAndPriceChecks(uint256 qty) {
        if (qty == 0) revert MintZero();
        if (qty > _maxMintPerTx()) revert MaxMintPerTx();
        if (_totalMinted() + qty > maxSupply) revert MaxSupply();
        if (msg.value < mintPrice * qty) revert MintPriceNotPaid();
        _;
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _maxMintPerTx() internal view virtual returns (uint256) {
        return 20;
    }

    function mintPublic(uint256 qty) external payable virtual supplyAndPriceChecks(qty) {
        _mint(msg.sender, qty);
    }

    //=========================================================================
    // Getters
    //=========================================================================

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        if (bytes(baseURI).length == 0) {
            return string(abi.encodePacked(unrevealedURI));
        }

        return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
    }

    // Need to override the owner for correct use in the next inheritance
    function owner() public view virtual override returns (address) {
        return super.owner();
    }

    //=========================================================================
    // Setters
    //=========================================================================

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function setBaseURI(string memory newURI) external onlyOwner {
        baseURI = newURI;
    }

    //=========================================================================
    // Withdraw
    //=========================================================================

    function withdrawEth() external onlyOwner {
        _withdrawEth(payable(msg.sender));
    }
}
