// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Aggregator {
    address public owner;
    address public pendingOwner;

    error NotOwner();
    error NotPendingOwner();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        pendingOwner = newOwner;
    }

    function acceptOwnership() external {
        if (msg.sender != pendingOwner) revert NotPendingOwner();
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}