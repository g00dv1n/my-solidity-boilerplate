// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC721 } from "solmate/tokens/ERC721.sol";
import { LibString } from "solmate/utils/LibString.sol";
import { IExtERC721Mintable } from "./interfaces/IExtERC721Mintable.sol";
import { Owned } from "./mixins/Owned.sol";
import { Receive } from "./mixins/Receive.sol";
import { Withdraw } from "./mixins/Withdraw.sol";

contract ExtERC721 is ERC721, IExtERC721Mintable, Owned, Receive, Withdraw {
    error MintPriceNotPaid();
    error MaxSupply();
    error NonExistentTokenURI();
    error MintZero();
    error MaxMintPerTx();

    uint256 public immutable maxSupply;
    uint256 public mintPrice;
    uint256 private currentIndex = 0;

    string public baseURI;
    string public unrevealedURI;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _unrevealedURI,
        uint256 _mintPrice,
        uint256 _maxSupply
    )
        ERC721(_name, _symbol)
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
        if (currentIndex + qty > maxSupply) revert MaxSupply();
        if (msg.value < mintPrice * qty) revert MintPriceNotPaid();
        _;
    }

    function _maxMintPerTx() internal view virtual returns (uint256) {
        return 20;
    }

    function mintPublic(uint256 qty) external payable virtual supplyAndPriceChecks(qty) {
        _mintBulk(msg.sender, qty);
    }

    /// @dev Gas-efficient bulk mint
    function _mintBulk(address to, uint256 qty) internal {
        require(to != address(0), "INVALID_RECIPIENT");

        uint256 id = currentIndex;

        unchecked {
            _balanceOf[to] += qty;

            for (uint256 i = 0; i < qty; i++) {
                ++id;

                require(_ownerOf[id] == address(0), "ALREADY_MINTED");
                _ownerOf[id] = to;

                emit Transfer(address(0), to, id);
            }

            currentIndex = id;
        }
    }

    //=========================================================================
    // Getters
    //=========================================================================

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }

        if (bytes(baseURI).length == 0) {
            return unrevealedURI;
        }

        return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
    }

    function totalSupply() public view virtual returns (uint256) {
        return currentIndex;
    }

    function mintInfo()
        public
        view
        virtual
        returns (uint256 maxSupply_, uint256 totalMinted_, uint256 mintPrice_, uint256 maxMintPerTx_)
    {
        maxSupply_ = maxSupply;
        totalMinted_ = totalSupply();
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
