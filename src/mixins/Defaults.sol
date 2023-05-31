// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Defaults {
    //=========================================================================
    // DEFAULT FUNCTIONS
    //=========================================================================
    receive() external payable { } // msg.data must be empty
    fallback() external payable { } // when msg.data is not empty
}
