// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";

interface IWETH {
    function balanceOf(address) external view returns (uint256);

    function deposit() external payable;
}

contract ForkTest is Test {
    IWETH public weth;

    function setUp() public {
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testInc() public {
        uint256 balanceBefore = weth.balanceOf(address(this));

        weth.deposit{value: 100}();

        uint256 balanceAfter = weth.balanceOf(address(this));

        assertEq(balanceBefore, 0);
        assertEq(balanceAfter, 100);
    }
}
