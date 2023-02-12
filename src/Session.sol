pragma solidity 0.8.17;

contract Session {

    address public sessionUser;

    struct Call {
        address target;
        bytes callData;
    }

    function startSession(Call[] calldata calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
        sessionUser = msg.sender;
        blockNumber = block.number;
        uint256 callsNumber = calls.length;
        returnData = new bytes[](callsNumber);
        bytes32 senderAddressBytes = _senderToBytes(msg.sender);
        for (uint256 i; i < callsNumber; ++i) {
            bytes32 addressFromRequest = bytes32(calls[i].callData[4 : 36]);
            require(addressFromRequest == bytes32(0x00), "should be zero address");
            uint256 length = calls[i].callData.length;
            bytes memory newCallData = new bytes(length);
            for (uint256 j; j < length; ++j) {
                if (j >= 16 && j < 36) {
                    newCallData[j] = senderAddressBytes[j - 16];
                } else {
                    newCallData[j] = calls[i].callData[j];
                }
            }
            (bool success, bytes memory ret) = calls[i].target.call(newCallData);
            require(success, "Multicall session failed");
            returnData[i] = ret;
        }
        sessionUser = address(0);
    }

    function _senderToBytes(address sender) internal pure returns (bytes32) {
        return bytes32(abi.encodePacked(sender));
    }
}
