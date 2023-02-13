// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract TestContract {

    function getSenderAddress(address sender) public returns (address) {
        return sender;
    }

    function getSenderAddressAndNumber(address sender, uint256 number) public returns (address, uint256) {
        return (sender, number);
    }

    function getSenderAddressAndNumberAndAddress(address sender, uint256 number, address account) public returns (address, uint256) {
        return (sender, number);
    }
    function getSenderAddressAndNumberAndArrayOfNumber(address sender, uint256 number, uint256[] calldata numbers) public returns (address, uint256) {
        return (sender, number);
    }

}
