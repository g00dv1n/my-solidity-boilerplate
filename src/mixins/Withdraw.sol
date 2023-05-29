// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Withdraw {
    error WithdrawTransfer();

    function _withdrawEth(address payable to) internal {
        uint256 balance = address(this).balance;

        (bool success,) = to.call{ value: balance }("");

        if (!success) {
            revert WithdrawTransfer();
        }
    }
}
