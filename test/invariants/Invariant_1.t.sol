//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {WETH} from "../../src/Weth.sol";

// Note: open testing - randomly call all public functions
/*
    (runs: 256, calls: 3840, reverts: 2228)
    2228 reverts out of 3840 calls
 */
contract WETH_Open_Invariant_Tests is Test {
    WETH private weth;

    function setUp() public {
        weth = new WETH();
    }

    function invariant_totalSupply_is_always_zero() public {
        assertEq(weth.totalSupply(), 0);
    }
}
