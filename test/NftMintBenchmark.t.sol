// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

import "@src/interfaces/IBaseERC721Mintable.sol";
import "@src/BaseERC721A.sol";
import "@src/BaseERC721.sol";

interface IMintTest {
    function mintPublic(uint256 qty) external payable;
    function balanceOf(address owner) external view returns (uint256);
}

contract NftTest is ExtendedTest {
    using stdStorage for StdStorage;

    BaseERC721 public nft1;
    BaseERC721A public nft2;
    uint256 public mp = 0.01 ether;
    uint256 public supply = 5555;
    uint256[] public bulkMintTests = [1, 2, 4, 8, 10, 12, 14, 16, 18, 20];

    receive() external payable { }

    function setUp() public {
        nft1 = new BaseERC721("TestNFT", "TSTN", "nft.xyz/", mp, supply);
        nft2 = new BaseERC721A("TestNFT", "TSTN", "nft.xyz/", mp, supply);
    }

    function mintBulk(uint256 qty, IBaseERC721Mintable nft) public {
        uint256 bulkMintAmount = qty;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);
        nft.mintPublic{ value: bulkMintAmount * mp }(bulkMintAmount);
    }

    function testMintBenchmark() public {
        for (uint256 i = 0; i < bulkMintTests.length; i++) {
            mintBulk(bulkMintTests[i], nft1);
            mintBulk(bulkMintTests[i], nft2);
        }
    }
}
