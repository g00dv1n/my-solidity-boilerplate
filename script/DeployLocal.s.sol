// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { ExtERC721A } from "@src/ExtERC721A.sol";
import { BaseScript } from "./BaseScript.s.sol";

contract DeployLocal is BaseScript {
    constructor() {
        useMnemonic();
    }

    function run() public broadcaster returns (ExtERC721A nft) {
        string memory mferMetadataSample = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/5688";

        nft = new ExtERC721A("TestNFT", "TSTN", mferMetadataSample, 0, 99);
    }
}
