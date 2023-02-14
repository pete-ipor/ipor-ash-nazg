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
        bytes32 senderAddressBytes = bytes32(abi.encodePacked(msg.sender));
        for (uint256 i; i < callsNumber; ++i) {
            bytes memory newCallData = calls[i].callData;
            assembly {
                mstore(add(newCallData, 48), or(and(mload(add(newCallData, 48)), not(shl(212, 0xFFFFFFFF))), senderAddressBytes))
            }
            (bool success, bytes memory ret) = calls[i].target.call(newCallData);
            require(success, "Multicall session failed");
            returnData[i] = ret;
        }
    }
}
