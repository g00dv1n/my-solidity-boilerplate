// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {Owned} from "solmate/auth/Owned.sol";
// import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Owned {
    string private baseURI;
    uint256 private currentIndex = 0;
    uint256 public immutable totalSupply;
    uint256 public immutable mintPrice;

    error MintPriceNotPaid();
    error MaxSupply();
    error NonExistentTokenURI();
    error WithdrawTransfer();
    error MintZero();

    constructor(string memory _baseURI) ERC721("SomeNFT", "SNFT") Owned(msg.sender) {
        baseURI = _baseURI;
        // set up supply and pricing
        totalSupply = 111;
        mintPrice = 0.1 ether;
    }

    //=========================================================================
    // Mint
    //=========================================================================

    modifier supplyChecks(uint256 _amount) {
        if (_amount == 0) revert MintZero();
        if (currentIndex + _amount > totalSupply) revert MaxSupply();
        _;
    }

    function mintPublic(uint256 _amount) external payable supplyChecks(_amount) {
        address recipient = msg.sender;

        if (msg.value < mintPrice * _amount) {
            revert MintPriceNotPaid();
        }

        for (uint256 i = 0; i < _amount; i++) {
            ++currentIndex;
            _safeMint(recipient, currentIndex);
        }
    }

    function mintPublic2(uint256 qty) external payable supplyChecks(qty) {
        if (msg.value < mintPrice * qty) {
            revert MintPriceNotPaid();
        }
        address recipient = msg.sender;
        uint256 tokenId = currentIndex;

        unchecked {
            for (uint256 i = 0; i < qty; i++) {
                ++tokenId;
                _mint(recipient, tokenId);
            }

            currentIndex = tokenId;
        }
    }

    function mintPublic3(uint256 qty) external payable supplyChecks(qty) {
        if (msg.value < mintPrice * qty) {
            revert MintPriceNotPaid();
        }

        _mintBulkOptimizedUnsafe(msg.sender, qty);
    }

    function _mintBulkOptimizedUnsafe(address to, uint256 qty) private {
        uint256 id = currentIndex;

        unchecked {
            _balanceOf[to] += qty;

            for (uint256 i = 0; i < qty; i++) {
                ++id;

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
            return "";
        }

        return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
    }

    //=========================================================================
    // DEFAULT
    //=========================================================================
    receive() external payable {} // msg.data must be empty
    fallback() external payable {} // when msg.data is not empty

    //=========================================================================
    // Withdraw
    //=========================================================================

    function withdrawEth() external onlyOwner {
        uint256 balance = address(this).balance;
        address payable to = payable(msg.sender);

        (bool success,) = to.call{value: balance}("");

        if (!success) {
            revert WithdrawTransfer();
        }
    }
}
