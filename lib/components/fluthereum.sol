// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract Shop is ERC721URIStorage{
    
    using Counters for Counters.Counter;
    Counters.Counter public NFTsCounter;
    Counters.Counter public NFTsIds;

    struct NFT{
        uint256 id; 
        string name;
        string description;
        string imageUrl; 
        uint price;
        address payable NFTowner;
    }

    mapping(uint256 => NFT) public allNFTs;
    mapping(address => NFT[]) public  myNFTs;
    mapping(address => uint256) public userBoughtCounts;
    mapping(address => uint256) public userSoldCounts;


    event TokenMinted(uint256 indexed tokenId, address indexed owner, string name, string description, string imageUrl, uint price);
    event TokenBought(uint256 indexed tokenId, address indexed owner, string name, string description, string imageUrl, uint price);

    constructor() ERC721("Shop", "SHOP"){
    }

    function mint(string memory name, string memory description, string memory imageUrl, uint price) 
    external returns(uint256){
        uint256 tokenId = NFTsIds.current();

        _safeMint(msg.sender, tokenId);
       // _setTokenURI(tokenId, imageUrl);

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
        return tokenId;
    }

    function buyNFT(uint256 tokenId) external payable{
        //require(msg.value >= allNFTs[tokenId].price, "Not enough ether");
        // address currentOwner = allNFTs[tokenId].NFTowner;
        // require(allNFTs[tokenId].NFTowner != msg.sender, "You are the owner of this NFT");

        // payable(allNFTs[tokenId].NFTowner).transfer(msg.value);
        // userBoughtCounts[msg.sender]++;
        // userSoldCounts[allNFTs[tokenId].NFTowner]++;
        // delete myNFTs[allNFTs[tokenId].NFTowner][tokenId];
        // allNFTs[tokenId].NFTowner = payable(msg.sender);
        // myNFTs[msg.sender].push(allNFTs[tokenId]);
    
        // emit TokenBought(tokenId, payable(msg.sender), allNFTs[tokenId].name, 
        // allNFTs[tokenId].description, allNFTs[tokenId].imageUrl, allNFTs[tokenId].price);
        address payable seller = allNFTs[tokenId].NFTowner;
        require(seller != msg.sender, "Cannot buy your own NFT");

        userBoughtCounts[msg.sender]+= 1;
        userSoldCounts[allNFTs[tokenId].NFTowner]+= 1;

        allNFTs[tokenId].NFTowner = payable(msg.sender);

        _transfer(seller, msg.sender, tokenId);
        seller.transfer(msg.value);
        
        //Update myNFTs mapping
        _removeNFTFromList(seller, tokenId);
        
        myNFTs[msg.sender].push(allNFTs[tokenId]);

        emit TokenBought(tokenId, payable(msg.sender), allNFTs[tokenId].name, 
            allNFTs[tokenId].description, allNFTs[tokenId].imageUrl, allNFTs[tokenId].price);
    }

    function deleteNFT(uint256 tokenId) external {
        require(allNFTs[tokenId].NFTowner == msg.sender, "You are not the owner of this NFT");
        
        delete allNFTs[tokenId];
        _removeNFTFromList(msg.sender, tokenId);
        _burn(tokenId);
        NFTsCounter.decrement();
    }

    function _removeNFTFromList(address user, uint256 tokenId) internal {
        uint256 length = myNFTs[user].length;
        for (uint256 i = 0; i < length; i++) {
            if (myNFTs[user][i].id == tokenId) {
                myNFTs[user][i] = myNFTs[user][length - 1];
                myNFTs[user].pop();
                break;
            }
        }
    }


    function getNFT(uint256 tokenId) public view returns(NFT memory){
        if(allNFTs[tokenId].NFTowner == address(0)){ 
            NFT memory empty = NFT({
            id: tokenId,
            name: '',
            description: '',
            imageUrl: '',
            price: 0,
            NFTowner: payable(address(0))
        });  
            return empty;     
        }
        return allNFTs[tokenId];
    }

    function getAllNFTs() public view returns(NFT[] memory){
        uint totalNFTs = NFTsCounter.current();
        NFT[] memory allNFTsArray = new NFT[](totalNFTs);
        uint y = 0;
        for(uint256 i = 0; i < totalNFTs; i++){
            if(allNFTs[i].NFTowner != address(0)){
                allNFTsArray[y] = allNFTs[i];
                y++;
            }
        }
        return allNFTsArray;
    }

    function getMyNFTs(address sender) public view returns(NFT[] memory){
        NFT[] memory temp = myNFTs[sender];
        return temp;
    }
    function getLenght(address sender) public view returns (uint){
        uint i = myNFTs[sender].length;
        return i;
    }
    function getCounter() public view returns (uint){
        return NFTsCounter.current();
    }
    function getIds() public view returns (uint){
        return NFTsIds.current();
    }
    function getSoldCount()public view returns (uint256){
        return userSoldCounts[msg.sender];
    }
    function getBoughtCount()public view returns (uint256){
        return userBoughtCounts[msg.sender];
    }
}
