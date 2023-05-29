// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/interfaces/IERC20.sol";

contract ForkTest is Test {
    IERC20 public dai;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {
        address whale = address(123);

        uint256 balBefore = dai.balanceOf(whale);
        console.log("balance before", balBefore);

        deal(address(dai), whale, 1e6 * 1e18);
        //function deal(address token, address to, uint256 give) external;

        uint256 balAfter = dai.balanceOf(whale);
        console.log("balance after", balAfter);

        assertEq(balAfter, 1e6 * 1e18);
    }
}
