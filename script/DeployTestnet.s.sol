// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseERC721A } from "@src/BaseERC721A.sol";
import { BaseScript } from "./Base.s.sol";

contract DeployTestnet is BaseScript {
    constructor() {
        usePrivateKey();
    }

    function run() public broadcaster returns (BaseERC721A nft) {
        // use mfer 1/1 metadata sample for testnet purpose
        string memory unrevealedURI = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/1337";
        uint256 price = 0 ether;
        uint256 supply = 99;

        nft = new BaseERC721A("ERC721A_NFT_Batch", "Batch", unrevealedURI, price, supply);
    }
}
