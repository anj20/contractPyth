pragma solidity ^0.8.0;

import { IEntropyConsumer } from "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import { IEntropy } from "@pythnetwork/entropy-sdk-solidity/IEntropy.sol";

contract RandomNumberGenerator is IEntropyConsumer {
    IEntropy public entropy;
    address public provider;
    uint64 public lastSequenceNumber;
    bytes32 public lastRandomNumber;

    constructor(address _entropyAddress) {
        entropy = IEntropy(_entropyAddress);
        provider = entropy.getDefaultProvider(); // Set default provider
    }

    // Request a random number from Entropy
    function requestRandomNumber() external payable {
        require(msg.value >= entropy.getFee(provider), "Insufficient fee sent");
        
        // Generate a 32-byte random number on the client side
        bytes32 randomNumber = keccak256(abi.encodePacked(block.timestamp, msg.sender));

        // Request a random number from Entropy
        lastSequenceNumber = entropy.requestWithCallback{value: msg.value}(provider, randomNumber);
    }

    // This function is called by the Entropy contract when a random number is generated
    function entropyCallback(
        uint64 sequenceNumber,
        address /* provider */,
        bytes32 randomNumber
    ) internal override {
        require(sequenceNumber == lastSequenceNumber, "Unexpected sequence number");

        // Update the stored random number
        lastRandomNumber = randomNumber;
    }

    // This method is required by the IEntropyConsumer interface
    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }

    // Fallback function to receive Ether
    receive() external payable {}
}
