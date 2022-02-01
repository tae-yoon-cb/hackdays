// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";

import "hardhat/console.sol";

/**
    @dev Simple smart contract that generates rarities
    -   1 NFTAlbum (Owned by a user) -> 1..N Collections
    -   1 Collection -> 1..N Items
 */
contract RandomRarity is VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 internal fee;           // link token fee for oracle
    uint256 internal randomResult;

    enum Rarity{ 
        COMMON, 
        RARE, 
        EPIC, 
        LEGENDARY 
    }

    // numbers are out of 10,000 so we can compare ints
    uint constant commonChance = 7223;
    uint constant rareChance = 2200;
    uint constant epicChance = 457;
    uint constant legendaryChance = 12;

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

    function getRarity(uint8 n)
        external
        returns (Rarity[] memory rarity)
    {
        Rarity[] memory rarities;
        uint c = 0;
        // randomResult is a 256bit integer - so ~ 77 base 10 units - in order to reduce costs, we can split this number into groups of 5 and get all 10 random numbers
        // if more than 15 random numbers are needed, we need to request for another number

        uint chainLinkCalls = n / 15 + 1; // e.g. 15 = 0 | 16 = 1 since int division uses floor
        for (uint i = 0; i < chainLinkCalls; i++) {
            getRandomNumber();
            for (uint j = 0; j < 15 || c < n; j++) { // restarts when we have found 15 cards or when N has been met - whichever is first
                string memory stringInt = Strings.toString(randomResult);
                string memory sub = substring(stringInt, j*5, j*5+4); // e.g. 0 - 4 | 5 - 9 ... 70 - 74

                uint256 random5Int = stringToUint(sub);
                if (random5Int < legendaryChance) {
                    rarities[c] = Rarity.LEGENDARY;
                } else if (random5Int < epicChance) {
                    rarities[c] = Rarity.EPIC;
                } else if (random5Int < rareChance) {
                    rarities[c] = Rarity.RARE;
                } else {
                    rarities[c] = Rarity.COMMON;
                }
                c++;
            }
        }
        return rarities;
    }

    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory res) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    function stringToUint(string memory numString) public pure returns(uint) {
        uint  val=0;
        bytes   memory stringBytes = bytes(numString);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
    }
}