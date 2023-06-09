// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./libraries/Base64.sol";

// to make our life easier we will inherit all features of ERC721
contract MyEpicNFT is ERC721URIStorage{ 

    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWord = ["Awesome", "Funny", "Lucky", "Jelly", "Bully", "Bullish", "Bearlish"];
    string[] secondWord = ["Shaky", "Biggy", "Danya", "Alba", "Eda", "Charik", "Ala", "Rol", "Klima"];
    string[] thirdWord = ["General", "Gnil", "Petush", "WithErika", "Fetish", "Mepth", "Temka"];

    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    uint256 totalNumberOfNFT;

    modifier checkNumberOfNFT() { 
        require(totalNumberOfNFT < 50, "All NFTs have minted!");
        _;
    }

    event newEpicNFTMinted(address sender, uint256 tokenID);

    // We need to pass the name of our NFTs token and its symbol.
    constructor () ERC721 ("SquareNFT", "SQUARE") { 
        console.log("This is my nft contract!");
    }

    function getTotalNFTsMintedSoFar() public view returns(uint256){ 
        console.log("%d NFTs have minted!", totalNumberOfNFT);
        return totalNumberOfNFT;
    }

    function pickFirstRandomWord(uint256 tokenId) public view returns(string memory){ 
        uint256 rand = random(string(abi.encodePacked("First Word", Strings.toString(tokenId))));
        rand =  rand % firstWord.length;
        //console.log(rand);
        return firstWord[rand];
    }

    function pickSecondRandomWord(uint256 tokenId) public view returns(string memory){ 
        uint256 rand = random(string(abi.encodePacked("Second Word", Strings.toString(tokenId))));
        rand =  rand % secondWord.length;
        return secondWord[rand];
    }

    function pickThirdRandomWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWord.length;
        return thirdWord[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory){ 
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    

    // A function our user will hit to get their NFT.
    function makeEpicNFT () public checkNumberOfNFT {  
         // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();
        string memory first = pickFirstRandomWord(newItemId);
        string memory second = pickSecondRandomWord(newItemId);
        string memory third = pickThirdRandomWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        console.log(combinedWord);

        string memory randomColor = pickRandomColor(newItemId);

        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));
         // Get all the JSON metadata in place and base64 encode it.
         string memory json = Base64.encode(
             bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "desctiption":"A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
             )
        ); 
        console.log("\n--------------------");
        console.log(json);
        console.log("--------------------\n");

        string memory finalTokenUri = string( 
            abi.encodePacked("data:application/json;base64,", json)
        );

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);
        // Return the NFT's metadata
        _setTokenURI(newItemId, finalTokenUri);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        emit newEpicNFTMinted(msg.sender,newItemId);
    }

    // Set the NFT's metadata
    function tokenURI(string memory svg, uint256 _tokenId) public view returns (string memory) {
        require(_exists(_tokenId));
        console.log("An NFT w/ ID %s has been minted to %s", _tokenId, msg.sender);
        return string(
            abi.encodePacked(
            "data:application/json;base64,",
            svg)
        );
    }
}