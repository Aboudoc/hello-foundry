// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../interfaces/IERC20Permit.sol";

contract GaslessTokenTransfer {
    /**
     * @dev There is 3 steps to implement this function
     * 1. call permit - sender approves this contract to spend amount + fee
     * 2. transferFrom sender to receiver the amount
     * transferFrom sender to msg.sender the fee
     * Use the params from the function permit() (ERC20Permit.sol)
     */
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);
        IERC20Permit(token).transferFrom(sender, receiver, amount);
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
