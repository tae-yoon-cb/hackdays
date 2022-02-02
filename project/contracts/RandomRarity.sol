// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";

import "hardhat/console.sol";

/**
    @dev Simple smart contract that allows you to create NFT collections.
    You create the collection and add items (NFTs) to the collection.
    Then you can query all metadata of a certain collection via 1 call.
    Notes:
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
    uint256 constant uint256Max = 2**35 - 1;

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

    function _random(uint maxNum) internal view returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % maxNum;
        return randomnumber;
    }

    function getRarity(uint8 n)
        external
        view
        returns (Rarity[] memory)
    {
        Rarity[] memory rarities = new Rarity[](n);
        uint c = 0;
        uint rCnt = 0;
        while (c < n) {
            console.log("Random call: %s", rCnt);
            // getRandomNumber();
            uint r  = _random(uint256Max);
            for (uint j = 0; r / (10000 ** (j+1))> 10 && c < n; j++) { // restarts when we have found 15 cards or when N has been met - whichever is first ** (j+1)));
                string memory stringInt = Strings.toString(r); // use randomresult when ready 
                string memory sub = substring(stringInt, j*4+1, j*4+5); // e.g. 0 - 3 | 4 - 7 ... 72 - 75

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
            rCnt++;
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