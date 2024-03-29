// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collection is ERC721URIStorage, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _totalMinted;
    mapping(address=>uint) private mintedAddress;
    mapping(string=>uint) private URIMapping;

    uint256 public PRICE_PER_TOKEN = 0.01 ether;
    uint256 public LIMIT_PER_ADDRESS = 2;
    uint256 public MAX_SUPPLY = 5;

    constructor() ERC721("Collection", "NFT"){}
    function setPrice(uint256 price) external onlyOwner{
        PRICE_PER_TOKEN = price;
    }

    function setLimit(uint256 limit) external onlyOwner{
        LIMIT_PER_ADDRESS = limit;
    }

    function setMaxSupply(uint256 max_supply) external onlyOwner{
        MAX_SUPPLY = max_supply;
    }

    function mintNFT(string memory tokenURI) payable external returns(uint256){
        require(PRICE_PER_TOKEN <= msg.value, "Ether paid is no sufficient");
        require(mintedAddress[msg.sender] < LIMIT_PER_ADDRESS, "you have exceeded minting limit");
        require(_totalMinted.current()+1<=MAX_SUPPLY, "You exceeded max supply");
        require(URIMapping[tokenURI] == 0, "This NFT has already been minted");

        URIMapping[tokenURI] += 1;
        mintedAddress[msg.sender] += 1;
        _tokenIds.increment();
        _totalMinted.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
        }

        function withdrawMoney() external onlyOwner{
            address payable to = payable(msg.sender);
            to.transfer(address(this).balance);
        }
}