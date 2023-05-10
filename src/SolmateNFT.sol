// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { ERC721 } from "solmate/tokens/ERC721.sol";
import { LibString } from "solmate/utils/LibString.sol";
import { Owned } from "solmate/auth/Owned.sol";

contract SolmateNFT is ERC721, Owned {
    string public baseURI;
    string public unrevealedURI;

    uint256 public immutable totalSupply;
    uint256 public mintPrice;
    uint256 private currentIndex = 0;

    error MintPriceNotPaid();
    error MaxSupply();
    error NonExistentTokenURI();
    error WithdrawTransfer();
    error MintZero();

    constructor(
        string memory _unrevealedURI,
        string memory _name,
        string memory _symbol,
        uint256 _mintPrice,
        uint256 _totalSupply
    )
        ERC721(_name, _symbol)
        Owned(msg.sender)
    {
        // set placeholder URI that will be using till reveal
        unrevealedURI = _unrevealedURI;

        // set up supply and pricing
        mintPrice = _mintPrice;
        totalSupply = _totalSupply;
    }

    //=========================================================================
    // Mint
    //=========================================================================
    modifier supplyAndPriceChecks(uint256 qty) {
        if (qty == 0) revert MintZero();
        if (currentIndex + qty > totalSupply) revert MaxSupply();
        if (msg.value < mintPrice * qty) revert MintPriceNotPaid();
        _;
    }

    function mintPublic(uint256 qty) external payable supplyAndPriceChecks(qty) {
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
            return string(abi.encodePacked(unrevealedURI));
        }

        return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
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
    // DEFAULT
    //=========================================================================
    receive() external payable { } // msg.data must be empty
    fallback() external payable { } // when msg.data is not empty

    //=========================================================================
    // Withdraw
    //=========================================================================

    function withdrawEth() external onlyOwner {
        uint256 balance = address(this).balance;
        address payable to = payable(msg.sender);

        (bool success,) = to.call{ value: balance }("");

        if (!success) {
            revert WithdrawTransfer();
        }
    }
}
