// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./TestContract.sol";
import "../src/Session.sol";

contract SessionTest is Test {
    Session public session;
    TestContract public testContract;

    function setUp() public {
        session = new Session();
        testContract = new TestContract();
    }

    function testShouldReturnSenderAddress() public {
        // given
        bytes memory callData = abi.encodeWithSignature(
            "getSenderAddress(address)",
            address(0)
        );
        Session.Call[] memory calls = new Session.Call[](1);
        calls[0] = Session.Call(address(testContract), callData);

        // when
        (uint256 blockNumber, bytes[] memory returnData) = session.startSession(calls);

        // then
        address sender = abi.decode(returnData[0], (address));
        assertEq(sender, address(this));
    }

    function testShouldReturnSenderAddressAndNumber() public {
        // given
        uint256 initNumber = 123;
        bytes memory callData = abi.encodeWithSignature(
            "getSenderAddressAndNumber(address,uint256)",
            address(0),
                initNumber
        );
        Session.Call[] memory calls = new Session.Call[](1);
        calls[0] = Session.Call(address(testContract), callData);

        // when
        (uint256 blockNumber, bytes[] memory returnData) = session.startSession(calls);

        // then
        (address sender, uint256 number) = abi.decode(returnData[0], (address, uint256));
        assertEq(sender, address(this));
        assertEq(number, initNumber);
    }


}
