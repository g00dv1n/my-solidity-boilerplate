// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC721A } from "ERC721A/ERC721A.sol";
import { IExtERC721Mintable } from "./interfaces/IExtERC721Mintable.sol";
import { Owned } from "./mixins/Owned.sol";
import { Receive } from "./mixins/Receive.sol";
import { Withdraw } from "./mixins/Withdraw.sol";

contract ExtERC721A is ERC721A, IExtERC721Mintable, Owned, Receive, Withdraw {
    error MintPriceNotPaid();
    error MaxSupply();
    error MintZero();
    error MaxMintPerTx();

    uint256 public immutable maxSupply;
    uint256 public mintPrice;

    string public baseURI;
    string public unrevealedURI;

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
            return unrevealedURI;
        }

        return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
    }

    function mintInfo()
        public
        view
        virtual
        returns (uint256 maxSupply_, uint256 totalMinted_, uint256 mintPrice_, uint256 maxMintPerTx_)
    {
        maxSupply_ = maxSupply;
        totalMinted_ = _totalMinted();
        mintPrice_ = mintPrice;
        maxMintPerTx_ = _maxMintPerTx();
    }

    // Need to override the owner and supportsInterface for correct use in the next inheritance
    function owner() public view virtual override returns (address) {
        return super.owner();
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return super.supportsInterface(interfaceId);
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
