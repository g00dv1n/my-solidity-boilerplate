// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SolmateNFT } from "@src/SolmateNFT.sol";
import { BaseScript } from "./Base.s.sol";

contract DeployLocal is BaseScript {
    constructor() {
        useMnemonic();
    }

    function run() public broadcaster returns (SolmateNFT nft) {
        string memory mferMetadataSample = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/5688";

        nft = new SolmateNFT(mferMetadataSample, "TestNFT", "TSTN", 0.0001 ether, 69);
    }
}
