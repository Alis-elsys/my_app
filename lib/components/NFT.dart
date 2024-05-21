import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import '../models/home_page_model.dart';
import '../pages/home_page.dart';


final HomePageModel _model = HomePageModel();

class NFT {
  final BigInt tokenId, price;
  final String name, description, imageUrl;
  late final EthereumAddress owner;
  late List<NFT> allNfts;
  // Add other attributes as needed

  NFT({
    required this.tokenId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.owner,
    // Add other attributes as needed
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      tokenId: BigInt.from(json['tokenId']),
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: BigInt.from(json['price']),
      owner: json['owner'] as EthereumAddress,
      // Parse other attributes as needed
    );
  }

  factory NFT.fromJsonList(List<dynamic> json) {
    print(json);
    return NFT(
      tokenId: json[0] as BigInt,
      name: json[1] as String,
      description: json[2] as String,
      imageUrl: json[3] as String,
      price: json[4] as BigInt,
      owner: json[5] as EthereumAddress,
      // Parse other attributes as needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
     // 'owner': owner,
      // Add other attributes as needed
    };
  }

  //mint NFT
 

}

//Get the info from the API
// Future<List<NFT>> fetchNFTData() async {

//   final response = await _HomePageWidgetState.getAllNFTs();
//   final data = jsonDecode(response) as List;  
//   return data.map((json) => NFT.fromJson(json)).toList();
// }



// Simulated data for demonstration purposes
  // List<NFT> nfts = [
  //   NFT(
  //     tokenId: BigInt.zero,
  //     name: 'NFT 0',
  //     description: 'This is a description for NFT 0',
  //     imageUrl: 'https://picsum.photos/250?image=18',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.one,
  //     name: 'NFT 1',
  //     description: 'This is a description for NFT 1',
  //     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.two,
  //     name: 'NFT 2',
  //     description: 'This is a description for NFT 2',
  //     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(3),
  //     name: 'NFT 3',
  //     description: 'This is a description for NFT 3',
  //     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(4),
  //     name: 'NFT 4',
  //     description: 'This is a description for NFT 4',
  //     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(5),
  //     name: 'NFT 5',
  //     description: 'This is a description for NFT 5',
  //     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8d2GaM9vp206kfNlnBUKdLFUNQMpy4SmWZxYssaNy1MVWtaJp9P4AJ9FngBRMQiWfj2c&usqp=CAU',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(6),
  //     name: 'NFT 6',
  //     description: 'This is a description for NFT 6',
  //     imageUrl: 'https://picsum.photos/250?image=14',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(7),
  //     name: 'NFT 7',
  //     description: 'This is a description for NFT 7',
  //     imageUrl: 'https://picsum.photos/250?image=15',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(8),
  //     name: 'NFT 8',
  //     description: 'This is a description for NFT 8',
  //     imageUrl: 'https://picsum.photos/250?image=16',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
  //   NFT(
  //     tokenId: BigInt.from(9),
  //     name: 'NFT 9',
  //     description: 'This is a description for NFT 9',
  //     imageUrl: 'https://picsum.photos/250?image=17',
  //     price: 100,
  //     owner: EthereumAddress.fromHex('${_model.myAddress}')
  //   ),
    
  // ];