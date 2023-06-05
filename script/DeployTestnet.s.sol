// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { OFilterTemplate } from "@src/OFilterTemplate.sol";
import { BaseScript } from "./BaseScript.s.sol";

contract DeployTestnet is BaseScript {
    constructor() {
        usePrivateKey();
    }

    function run() public broadcaster returns (OFilterTemplate nft) {
        // use mfer 1/1 metadata sample for testnet purpose
        string memory unrevealedURI = "https://ipfs.io/ipfs/QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/1";
        // uint256 price = 0 ether;
        // uint256 supply = 99;

        nft = new OFilterTemplate(unrevealedURI);
    }
}
