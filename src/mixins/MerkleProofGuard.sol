// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { MerkleProofLib } from "solmate/utils/MerkleProofLib.sol";

abstract contract MerkleProofGuard {
    modifier checkMerkleProofByAddr(bytes32[] calldata proof, bytes32 root, address addrToCheck) {
        bytes32 leaf = keccak256(abi.encodePacked(addrToCheck));
        require(MerkleProofLib.verify(proof, root, leaf) == true, "INVALID_MRKL_PROOF");
        _;
    }

    modifier checkMerkleProof(bytes32[] calldata proof, bytes32 root, bytes32 leafToCheck) {
        require(MerkleProofLib.verify(proof, root, leafToCheck) == true, "INVALID_MRKL_PROOF");
        _;
    }
}
