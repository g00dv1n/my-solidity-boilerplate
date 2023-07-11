// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Receive {
    //=========================================================================
    // DEFAULT RECEIVE FUNCTION
    //=========================================================================
    receive() external payable { } // msg.data must be empty
}
