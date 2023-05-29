// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

import "@src/BatchMintNFT.sol";

contract NftTest is ExtendedTest {
    using stdStorage for StdStorage;

    BatchMintNFT public nft;
    uint256 public correctMintPrice = 0.01 ether;
    uint256 public supply = 100;
    uint256 public incorrectMintPrice = 1 wei;

    receive() external payable { }

    function setUp() public {
        nft = new BatchMintNFT("nft.xyz/", "TestNFT", "TSTN", correctMintPrice, supply);
        correctMintPrice = nft.mintPrice();
    }

    function testMintBulk20() public {
        uint256 bulkMintAmount = 20;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);

        nft.mintPublic{ value: bulkMintAmount * correctMintPrice }(bulkMintAmount);

        assertEq(nft.balanceOf(owner), bulkMintAmount);
    }

    function testMintBulk10() public {
        uint256 bulkMintAmount = 10;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);

        nft.mintPublic{ value: bulkMintAmount * correctMintPrice }(bulkMintAmount);

        assertEq(nft.balanceOf(owner), bulkMintAmount);
    }

    function testMintBulk5() public {
        uint256 bulkMintAmount = 5;
        address owner = _randomNonZeroAddress();

        _prankAndFund(owner);
        nft.mintPublic{ value: bulkMintAmount * correctMintPrice }(bulkMintAmount);

        assertEq(nft.balanceOf(owner), bulkMintAmount);
    }

    function testMintOne() public {
        nft.mintPublic{ value: correctMintPrice }(1);
    }

    function testFailMintPricePaid() public {
        nft.mintPublic{ value: incorrectMintPrice }(1);
    }

    function testWithdrawPricePaid() public {
        (bool success,) = payable(nft).call{ value: correctMintPrice * 10 }("");

        assertEq(success, true);

        nft.withdrawEth();
    }
}
