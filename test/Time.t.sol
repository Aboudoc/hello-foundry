// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract TimeTest is Test {
    Auction public auction;
    uint256 public startAt;

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
    }

    function testBidFailBeforeStartTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    function testBidFailAfterEndTime() public {
        vm.expectRevert(bytes("cannot bid"));
        vm.warp(startAt + 2 days);
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;
        skip(100);
        assertEq(block.timestamp, t + 100);

        rewind(10);
        assertEq(block.timestamp, t + 90);
    }

    function testBlockNumber() public {
        uint256 b = block.number;
        vm.roll(999);
        assertEq(block.number, 999);
    }
}
