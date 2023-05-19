// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SolmateNFT } from "@src/SolmateNFT.sol";
import { BaseScript } from "./Base.s.sol";

contract DeployTestnet is BaseScript {
    constructor() {
        usePrivateKey();
    }

    function run() public broadcaster returns (SolmateNFT nft) {
        // use mfer 1/1 metadata sample for testnet purpose
        string memory unrevealedURI = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/5688";
        uint256 price = 1 gwei;
        uint256 supply = 69;

        nft = new SolmateNFT(unrevealedURI, "1337NFT", "1337", price, supply);
    }
}
