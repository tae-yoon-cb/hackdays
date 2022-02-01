// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

import "hardhat/console.sol";

/**
    @dev Simple smart contract that connects to a Chainlink Oracle to receive a random number
 */
contract RandomRarity is VRFConsumerBase {

    bytes32 public keyHash;
    uint256 public fee; // link token fee for oracle
    uint256 public randomResult;

    enum Rarity{ COMMON, RARE, EPIC, LEGENDARY }

    fixed constant commonChance = 0.7223;
    fixed constant rareChance = 0.22;
    fixed constant epicChance = 0.0457;
    fixed constant legendaryChance = 0.012;

    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Ropsten Testnet
     * Chainlink VRF Coordinator address: 0xf720CF1B963e0e7bE9F58fd471EFa67e7bF00cfb
     * LINK token address:                0x20fE562d797A42Dcb3399062AE9546cd06f63280
     * Key Hash: 0xced103054e349b8dfb51352f0f8fa9b5d20dde3d06f9f43cb2b85bc64b238205
     */
    constructor()
            VRFConsumerBase(
            0xf720CF1B963e0e7bE9F58fd471EFa67e7bF00cfb, // VRF Coordinator
            0x20fE562d797A42Dcb3399062AE9546cd06f63280  // LINK Token
        )
    {
        keyHash = 0xced103054e349b8dfb51352f0f8fa9b5d20dde3d06f9f43cb2b85bc64b238205;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
    }

    /** 
     * Requests randomness 
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32, uint256 randomness) internal override {
        randomResult = randomness;
    }

    // function getRarity()
    //     external
    //     view
    //     returns (Rarity rarity)
    // {
    //     // Call Chainlink oracle to get random number
    //     // 

    // }

}