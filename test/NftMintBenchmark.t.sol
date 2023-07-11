// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

import "@src/interfaces/IExtERC721Mintable.sol";
import "@src/ExtERC721A.sol";
import "@src/ExtERC721.sol";
import "@src/OFilterTemplate.sol";

contract NftTest is ExtendedTest {
    using stdStorage for StdStorage;

    ExtERC721 public nft;
    ExtERC721A public nftA;
    OFilterTemplate public nftOFilter;

    uint256 public mp = 0.01 ether;
    uint256 public supply = 5555;
    uint256[] public bulkMintTests = [1, 2, 4, 8, 10, 12, 14, 16, 18, 20];

    receive() external payable { }

    function setUp() public {
        nft = new ExtERC721("TestNFT", "TSTN", "nft.xyz/", mp, supply);
        nftA = new ExtERC721A("TestNFT", "TSTN", "nft.xyz/", mp, supply);
        nftOFilter = new OFilterTemplate("nft.xyz/");
    }

    function mintBulk(uint256 qty, IExtERC721Mintable _nft) public {
        uint256 bulkMintAmount = qty;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);
        _nft.mintPublic{ value: bulkMintAmount * mp }(bulkMintAmount);
    }

    function testMintBenchmark() public {
        for (uint256 i = 0; i < bulkMintTests.length; i++) {
            mintBulk(bulkMintTests[i], nft);
            mintBulk(bulkMintTests[i], nftA);
            mintBulk(bulkMintTests[i], nftOFilter);
        }
    }
}
