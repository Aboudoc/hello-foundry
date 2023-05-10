// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract SignTest is Test {
    function testSignature() public {
        uint256 privateKey = 123;
        address pubKey = vm.addr(privateKey);

        bytes32 messageHash = keccak256("Secret message");

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        address signer = ecrecover(messageHash, v, r, s);

        assertEq(pubKey, signer);

        bytes32 wrongMessage = keccak256("scam");

        signer = ecrecover(wrongMessage, v, r, s);

        assertTrue(signer != pubKey);
    }
}
