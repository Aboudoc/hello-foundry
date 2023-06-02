// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

// Topics
// - fuzz
// - assume and bound
// - stats
//   (runs: 256, μ: 18301, ~: 10819)
//   runs - number of tests
//   μ - mean gas used
//   ~ - median gas used

contract FuzzTest is Test {
    Bit public bit;

    function setUp() public {
        bit = new Bit();
    }

    function mostSignificantBit(uint x) private pure returns (uint) {
        uint i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificantBitManual() public {
        assertEq(mostSignificantBit(0), 0);
        assertEq(mostSignificantBit(1), 0);
        assertEq(mostSignificantBit(2), 1);
        assertEq(mostSignificantBit(4), 2);
        assertEq(mostSignificantBit(8), 3);
        assertEq(mostSignificantBit(type(uint).max), 255);
    }

    function testMostSignificantBitFuzz(uint x) public {
        // assume(x > 0);
        // assertGt(x, 0);

        bound(x, 1, 10);
        // assertGe(x, 1);
        // assertLe(x, 10);

        uint i = bit.mostSignificantBit(x);
        assertEq(i, mostSignificantBit(x));
    }
}
