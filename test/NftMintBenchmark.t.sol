// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

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

    receive() external payable { }

    function setUp() public {
        nft1 = new BaseERC721("TestNFT", "TSTN", "nft.xyz/", mp, supply);
        nft2 = new BaseERC721A("TestNFT", "TSTN", "nft.xyz/", mp, supply);
    }

    function mintBulk1(uint256 qty) public {
        uint256 bulkMintAmount = qty;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);
        nft1.mintPublic{ value: bulkMintAmount * mp }(bulkMintAmount);
    }

    function mintBulk2(uint256 qty) public {
        uint256 bulkMintAmount = qty;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);
        nft2.mintPublic{ value: bulkMintAmount * mp }(bulkMintAmount);
    }

    function testMintBenchmark() public {
        // 1
        mintBulk1(1);
        mintBulk2(1);

        // 5
        mintBulk1(5);
        mintBulk2(5);

        // 10
        mintBulk1(10);
        mintBulk2(10);

        // 15
        mintBulk1(15);
        mintBulk2(15);

        // 20
        mintBulk1(20);
        mintBulk2(20);
    }

    // function testFailMintPricePaid() public {
    //     nft.mintPublic{ value: incorrectMintPrice }(1);
    // }

    // function testWithdrawPricePaid() public {
    //     (bool success,) = payable(nft).call{ value: correctMintPrice * 10 }("");

    //     assertEq(success, true);

    //     nft.withdrawEth();
    // }
}
