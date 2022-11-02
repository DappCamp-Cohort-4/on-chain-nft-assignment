// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "base64/base64.sol" as Base64Lib;
import "../src/DappCampNFT.sol";

contract DappCampNFTTest is Test {
    DappCampNFT public dappcampNFT;

    bytes internal constant TABLE_DECODE =
        hex"0000000000000000000000000000000000000000000000000000000000000000"
        hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
        hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
        hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    struct NFT {
        string description;
        string image;
        string name;
    }

    function substring(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function setUp() public {
        dappcampNFT = new DappCampNFT();
    }

    function testClaimWithValidTokenId() public {
        dappcampNFT.claim(1);

        string memory tokenURI = dappcampNFT.tokenURI(1);
        uint256 tokenURILen = bytes(tokenURI).length;

        // Removing "data:application/json;base64" from tokenURI
        string memory metadataJson = substring(tokenURI, 29, tokenURILen);

        bytes memory base64DecodedJSON = Base64Lib.Base64.decode(metadataJson);
        string memory jsonString = string(base64DecodedJSON);
        bytes memory parsedJSON = vm.parseJson(jsonString);

        abi.decode(parsedJSON, (NFT));
    }
}
