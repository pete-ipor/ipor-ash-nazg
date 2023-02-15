pragma solidity 0.8.17;

contract Session {
    /// @dev The struct of call contain the address of the contract and the call data
    struct Call {
        address target;
        bytes callData;
    }

    /// @notice Method run multiple calls in one transaction, and pass msg.sender as first argument in each call
    /// @param calls list of calls with target contract address and call data
    /// @return blockNumber block number of transaction and returnData list of return data from each call
    function startSession(Call[] calldata calls) external returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        uint256 callsNumber = calls.length;
        returnData = new bytes[](callsNumber);
        bytes32 senderAddressBytes = bytes32(abi.encodePacked(msg.sender));

        for (uint256 i; i < callsNumber; ++i) {
            bytes memory newCallData = calls[i].callData;
            bytes32 addressFromRequest = bytes32(calls[i].callData[4 : 36]);
            require(addressFromRequest == bytes32(0x00), "Address pass as first parameter should be zero address");
            assembly {
                mstore(add(newCallData, 48), or(and(mload(add(newCallData, 48)), not(shl(212, 0xFFFFFFFF))), senderAddressBytes))
            }
            (bool success, bytes memory ret) = calls[i].target.call(newCallData);
            require(success, "Multicall session failed");
            returnData[i] = ret;
        }
    }

    /// @notice Contract ID. The keccak-256 hash of "io.ipor.AshNazg" decreased by 1
    /// @return Returns an ID of the contract
    function getContractId() external pure returns (bytes32) {
        return 0x4e243030378241c808328f5c5d7c5ec677ca78134d38ed01f2d5159cc3e6096c;
    }
}
