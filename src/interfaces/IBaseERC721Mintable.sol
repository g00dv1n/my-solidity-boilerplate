// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IBaseERC721Mintable {
    function mintPublic(uint256 qty) external payable;
}
