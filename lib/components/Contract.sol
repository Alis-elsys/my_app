// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Shop is Ownable, ERC721URIStorage {
    
    using Counters for Counters.Counter;
    Counters.Counter public NFTsCounter;
    Counters.Counter public NFTsIds; 
    int public tester;
    address private Glob_owner;

    struct NFT{
        uint256 id; //moje bi trqbva da promenq na float zaradi flutter constructiona
        string name;
        string description;
        string imageUrl; 
        uint256 price;
        address payable NFTowner;
    }

    mapping(uint256 => NFT) public allNFTs;
    mapping(address => NFT[]) public  myNFTs;
    mapping(address => uint256) public userBoughtCounts;
    mapping(address => uint256) public userSoldCounts;


    event TokenMinted(uint256 indexed tokenId, address indexed owner, string name, string description, string imageUrl, uint price);
    event TokenBought(uint256 indexed tokenId, address indexed owner, string name, string description, string imageUrl, uint price);

    constructor(address initialOwner) ERC721("Shop", "SHOP") Ownable(initialOwner) {
        Glob_owner = initialOwner;
    }

    function mint(string memory name, string memory description, string memory imageUrl, uint price) external onlyOwner returns(uint256){
        
        uint256 tokenId = NFTsIds.current();

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, imageUrl);

        NFT memory newNFT = NFT({
            id: tokenId,
            name: name,
            description: description,
            imageUrl: imageUrl,
            price: price,
            NFTowner: payable(msg.sender)
        });        
        
        allNFTs[tokenId] = newNFT;
        myNFTs[msg.sender].push(newNFT);

        
        emit TokenMinted(tokenId, payable(msg.sender), name, description, imageUrl, price);

        NFTsCounter.increment();
        NFTsIds.increment();
        tester++;
        return tokenId;
    }

    function buyNFT(uint256 tokenId) external payable{
        require(msg.value >= allNFTs[tokenId].price, "Not enough ether");
        require(allNFTs[tokenId].NFTowner != msg.sender, "You are the owner of this NFT");

        payable(allNFTs[tokenId].NFTowner).transfer(msg.value);
        userBoughtCounts[msg.sender]++;
        userSoldCounts[allNFTs[tokenId].NFTowner]++;
        myNFTs[msg.sender].push(allNFTs[tokenId]);
        /// myNFTs[msg.sender] = allNFTs[tokenId];

        emit TokenBought(tokenId, payable(msg.sender), allNFTs[tokenId].name, allNFTs[tokenId].description, allNFTs[tokenId].imageUrl, allNFTs[tokenId].price);
    }

    function deleteNFT(uint256 tokenId) external onlyOwner{
        delete allNFTs[tokenId];
        myNFTs[msg.sender].pop(); 
        _burn(tokenId);
        NFTsCounter.decrement();
    }

    function getNFT(uint256 tokenId) public view returns(NFT memory){
       // if(tokenId = allNFTs[tokenId].NFTowner == address(0)){        }
        return allNFTs[tokenId];
    }

    function getAllNFTs() public view returns(NFT[] memory){
        NFT[] memory allNFTsArray = new NFT[](NFTsCounter.current());
        for(uint256 i = 0; i < NFTsCounter.current(); i++){
            allNFTsArray[i] = allNFTs[i];
        }
        return allNFTsArray;
    }

    function getMyNFTs() public view returns(NFT[] memory){
        return myNFTs[msg.sender];
    }

    function getLenght(address sender) public view returns (uint){
        return myNFTs[sender].length;
    }

    function getFullLenght() public view returns (uint){
        NFT[] memory allNFTsArray = new NFT[](NFTsCounter.current());
        for(uint256 i = 0; i < NFTsCounter.current(); i++){
            allNFTsArray[i] = allNFTs[i];
        }
        return allNFTsArray.length;
    }

    function getCounter() public view returns (uint){
        return NFTsCounter.current();
    }

    function getIds() public view returns (uint){
        return NFTsIds.current();
    }

    function getTester() public view returns (int){
        return tester;
    }

}
