// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SolmateNFT } from "@src/SolmateNFT.sol";
import { BaseScript } from "./Base.s.sol";

contract DeployLocal is BaseScript {
    constructor() {
        useMnemonic();
    }

    function run() public broadcaster returns (SolmateNFT nft) {
        nft = new SolmateNFT("nft.xyz/", "TestNFT", "TSTN", 0.01 ether, 111);
    }
}
