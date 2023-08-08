// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

import "@src/mixins/MerkleProofGuard.sol";

contract SimpleMerkleUsage is MerkleProofGuard {
    bytes32 merkleRoot = 0xe355d00a8bf56103ff770f6c6acf4b3a0d85927f4054060a526106470c50ee18;

    function fnWithoutMerkle() public { }

    function fnWithMerkle(
        bytes32[] calldata proof,
        address validAddr
    )
        public
        checkMerkleProofByAddr(proof, merkleRoot, validAddr)
    { }
}

contract MerkleTest is ExtendedTest {
    SimpleMerkleUsage smu = new SimpleMerkleUsage();

    address validAddr = 0xB7998316a85884122769878dBa9484a1D2f25b80;

    bytes32[] validProof = [
        bytes32(0x93230d0b2377404a36412e26d231de4c7e1a9fb62e227b420200ee950a5ca9c0),
        bytes32(0xee068f44d79b0b5ec5c9fdce424d1cb399ed31b481f41d901b2d90447857ca89)
    ];

    function testMerkleGasUsage() public {
        smu.fnWithoutMerkle();
        smu.fnWithMerkle(validProof, validAddr);
    }
}
