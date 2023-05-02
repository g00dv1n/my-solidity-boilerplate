// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";
import "@src/NFT.sol";

contract NftTest is ERC721TokenReceiver, Test {
    using stdStorage for StdStorage;

    NFT public nft = new NFT("nft.xyz/");
    uint256 public correctMintPrice = nft.mintPrice();
    uint256 public incorrectMintPrice = 1 wei;
    uint256 public bulkMintAmount = 10;

    receive() external payable {}

    function setUp() public {}

    function testMintPricePaid() public {
        nft.mintPublic{value: bulkMintAmount * correctMintPrice}(bulkMintAmount);
    }

    function testMint2PricePaid() public {
        nft.mintPublic2{value: bulkMintAmount * correctMintPrice}(bulkMintAmount);
    }

    function testMin32PricePaid() public {
        nft.mintPublic3{value: bulkMintAmount * correctMintPrice}(bulkMintAmount);
    }

    // function testFailMintPricePaid() public {
    //     nft.mintPublic{value: incorrectMintPrice}(bulkMintAmount);
    // }

    // function testWithdrawPricePaid() public {
    //     nft.mintPublic{value: correctMintPrice}(bulkMintAmount);

    //     console.log("Eth balance before =", address(nft).balance);

    //     nft.withdrawEth();

    //     console.log("Eth balance after =", address(nft).balance);
    // }
}
