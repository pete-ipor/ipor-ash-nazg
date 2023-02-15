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

    function testShouldRejectWhenNoTZeroAddressWasSend() public {
        // given
        address sendAddress = _getUserAddress(1);
        bytes memory callData = abi.encodeWithSignature(
            "getSenderAddress(address)",
            sendAddress
        );
        Session.Call[] memory calls = new Session.Call[](1);
        calls[0] = Session.Call(address(testContract), callData);

        console2.log("sendAddress", sendAddress);
        console.logBytes(callData);
        // when
        vm.expectRevert("should be zero address");
        (uint256 blockNumber, bytes[] memory returnData) = session.startSession(calls);

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

    function testShouldReturnSenderAddressAndMaxUint256() public {
        // given
        uint256 initNumber = type(uint256).max;

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

    function testShouldReturnSenderAddressAndNumber2() public {
        // given
        uint256 initNumber = 123;
        uint256[] memory numbers = new uint256[](2);
        numbers[0] = 1;
        numbers[1] = 2;
        bytes memory callData = abi.encodeWithSignature(
            "getSenderAddressAndNumberAndArrayOfNumber(address,uint256,uint256[])",
            address(0),
            initNumber,
            numbers

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

    function testShouldReturnSenderAddressAndNumber3() public {
        // given
        uint256 initNumber = 123;
        bytes memory callData = abi.encodeWithSignature(
            "getSenderAddressAndNumberAndAddress(address,uint256,address)",
            address(0),
            initNumber,
            address(this)

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

    function testShouldReturnSenderAddressAndNumber4() public {
        // given
        uint256 initNumber = 123;
        bytes memory callData1 = abi.encodeWithSignature(
            "getSenderAddressAndNumberAndAddress(address,uint256,address)",
            address(0),
            initNumber,
            address(this)

        );
        bytes memory callData2 = abi.encodeWithSignature(
            "getSenderAddress(address)",
            address(0)
        );
        bytes memory callData3 = abi.encodeWithSignature(
            "getSenderAddressAndNumber(address,uint256)",
            address(0),
            initNumber
        );

        Session.Call[] memory calls = new Session.Call[](3);
        calls[0] = Session.Call(address(testContract), callData1);
        calls[1] = Session.Call(address(testContract), callData2);
        calls[2] = Session.Call(address(testContract), callData3);

        // when
        (uint256 blockNumber, bytes[] memory returnData) = session.startSession(calls);

        // then
        (address sender, uint256 number) = abi.decode(returnData[0], (address, uint256));
        assertEq(sender, address(this));
        assertEq(number, initNumber);
    }

    function _getUserAddress(uint256 number) internal returns (address) {
        return vm.rememberKey(number);
    }
}
