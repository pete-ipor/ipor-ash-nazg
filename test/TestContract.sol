// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract TestContract {

    function getSenderAddress(address sender) public returns (address) {
        return sender;
    }

    function getSenderAddressAndNumber(address sender, uint256 number) public returns (address, uint256) {
        return (sender, number);
    }
}
