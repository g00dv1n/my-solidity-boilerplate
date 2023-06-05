// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { BaseERC721A } from "@src/BaseERC721A.sol";
import { BaseScript } from "./BaseScript.s.sol";

contract DeployLocal is BaseScript {
    constructor() {
        useMnemonic();
    }

    function run() public broadcaster returns (BaseERC721A nft) {
        string memory mferMetadataSample = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/5688";

        nft = new BaseERC721A("TestNFT", "TSTN", mferMetadataSample, 0.0001 ether, 69);
    }
}
