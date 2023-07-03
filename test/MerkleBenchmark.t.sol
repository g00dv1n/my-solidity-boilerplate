// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "solmate/tokens/ERC721.sol";

import "./utils/ExtendedTest.sol";

import "@src/mixins/MerkleProofGuard.sol";

contract SimpleMerkleUsage is MerkleProofGuard {
    bytes32 merkleRoot = 0xd2525192efc50f4e4b22f4c5c8188ebafb1ede3a90842f8788c7ae1422cca234;

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
    using stdStorage for StdStorage;

    SimpleMerkleUsage smu = new SimpleMerkleUsage();

    function testMerkleGasUsage() public {
        address validAddr = 0xB7998316a85884122769878dBa9484a1D2f25b80;

        bytes32[] memory proof = new bytes32[](2);

        proof[0] = bytes32(0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229);
        proof[1] = bytes32(0x050bafc3fbff3f13ae92e34d22935ed341803bcf7a4b840ce8ba265bf765bf79);

        smu.fnWithoutMerkle();
        smu.fnWithMerkle(proof, validAddr);
    }
}
