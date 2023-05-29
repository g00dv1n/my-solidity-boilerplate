// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BatchMintNFT } from "@src/BatchMintNFT.sol";
import { BaseScript } from "./Base.s.sol";

contract DeployLocal is BaseScript {
    constructor() {
        useMnemonic();
    }

    function run() public broadcaster returns (BatchMintNFT nft) {
        string memory mferMetadataSample = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/5688";

        nft = new BatchMintNFT(mferMetadataSample, "TestNFT", "TSTN", 0.0001 ether, 69);
    }
}
