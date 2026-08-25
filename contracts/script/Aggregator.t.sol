// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Aggregator} from "../src/Aggregator.sol";

contract AggregatorTest is Test {
    Aggregator aggregator;

    address owner = makeAddr("owner");
    address newOwner = makeAddr("newOwner");
    address stranger = makeAddr("stranger");

    function setUp() public {
        vm.prank(owner);
        aggregator = new Aggregator();
    }

    function test_InitialOwner() public {
        assertEq(aggregator.owner(), owner);
    }

    function test_TransferOwnership() public {
        vm.prank(owner);

        aggregator.transferOwnership(newOwner);

        assertEq(aggregator.pendingOwner(), newOwner);
    }

    function test_RevertIf_NotOwner() public {
        vm.prank(stranger);

        vm.expectRevert(Aggregator.NotOwner.selector);

        aggregator.transferOwnership(newOwner);
    }

    function test_OwnershipTransfer() public {
        vm.prank(owner);
        aggregator.transferOwnership(newOwner);

        assertEq(aggregator.pendingOwner(), newOwner);

        vm.prank(newOwner);
        aggregator.acceptOwnership();

        assertEq(aggregator.owner(), newOwner);
        assertEq(aggregator.pendingOwner(), address(0));
    }

    function test_RevertIf_NotPendingOwner() public {
        vm.prank(owner);
        aggregator.transferOwnership(newOwner);

        vm.prank(stranger);

        vm.expectRevert(Aggregator.NotPendingOwner.selector);

        aggregator.acceptOwnership();
    }
}