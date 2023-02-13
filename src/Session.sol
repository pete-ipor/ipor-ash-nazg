pragma solidity 0.8.17;

contract Session {
    struct Call {
        address target;
        bytes callData;
    }

    function startSession(Call[] calldata calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        uint256 callsNumber = calls.length;
        returnData = new bytes[](callsNumber);
        bytes32 senderAddressBytes = _senderToBytes(msg.sender);
        for (uint256 i; i < callsNumber; ++i) {
            bytes32 addressFromRequest = bytes32(calls[i].callData[4 : 36]);
            require(addressFromRequest == bytes32(0x00), "should be zero address");
            bytes memory newCallData = calls[i].callData;
            for (uint256 j = 16; j < 36; ++j) {
                newCallData[j] = senderAddressBytes[j - 16];
            }
            (bool success, bytes memory ret) = calls[i].target.call(newCallData);
            require(success, "Multicall session failed");
            returnData[i] = ret;
        }
    }

    function _senderToBytes(address sender) internal pure returns (bytes32) {
        return bytes32(abi.encodePacked(sender));
    }
}
