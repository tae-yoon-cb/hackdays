// contracts/CardCollection.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CardCollection is ERC721 {
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint8 private constant PACK_SIZE = 10;

    Counters.Counter private _tokenIds;
    string private _baseUri;

    // Set baseURI when we deploy the contract to the base location of the json metadata on ipfs
    // i.e. https://gateway.pinata.cloud/ipfs/QmaBAT25ferdCHvqxqXst7cw1AKxn2r2zNjWDiHXnqVanQ/
    constructor(string memory baseURI)
        ERC721("HackdaysCardCollection", "CBHCC")
    {
        _baseUri = baseURI;
    }

    // Override token URI to concatenate _baseUri + tokenId + ".json
    // i.e. https://gateway.pinata.cloud/ipfs/QmaBAT25ferdCHvqxqXst7cw1AKxn2r2zNjWDiHXnqVanQ/1.json
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            bytes(_baseUri).length > 0
                ? string(
                    abi.encodePacked(_baseUri, tokenId.toString(), ".json")
                )
                : "";
    }

    // Example buyPack function
    function buyPack(address receiver)
        public
        returns (
            uint256 /*[] memory*/
        )
    {
        //* Example loop to mint 10 vs 1, maybe this should be an 1155 to save $$$
        //uint256[] memory cards = new uint[](PACK_SIZE);
        //for (uint8 i = 0; i < PACK_SIZE; i++) {

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(
            receiver, // could use msg.sender here, but overriding for testing purposes
            newItemId
        );

        //cards[i] = newItemId;
        //}

        return newItemId; /* cards */
    }
}
