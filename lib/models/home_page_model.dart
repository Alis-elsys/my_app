import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import '../components/NFT.dart';
import 'package:http/http.dart' as http;
import '../components/nav_bar.dart';
import '../pages/home_page.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';




class HomePageModel extends HomePageWidget {
  bool fullList = true;
 // String _url = "HTTP://127.0.0.1:7545";
//String _wsUrl = "ws://127.0.0.1:7545/";

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  ExpandableController? isExpanded;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for NavBar1 component.
  late NavBar navBarModel;
  List<NFT> allNfts = [];
  List<NFT> myNfts = [];  
  late http.Client _httpClient;
    late Web3Client _ethClient;
    late DeployedContract _contract;
    final String blockchainUrl =
      "https://sepolia.infura.io/v3/7f0484b1a988417e9be1706dd241a9fd"; //Endpoint for the blockchain
    final String apiKey = "FdTLCM20fELyB/28wtHUxbnRuicnICMQl1tC2ejUQzWUuYh2vGabFQ";
    String contractName = "Fluthereum";
    late String contractAddress;
    String privateKey =
    "5e0b7dd43a57934770bb8e7d563d26cc94f4c9cb4ec04c72e20cf1bee4cd66c3";
    late EthPrivateKey credential;
    String myAddress = /*"0x0000000000000000000000000000000000000000";*/ "0x5e5386C139c5A9F9d99a743Ff10647b140AB543c";
    String? tempAddress = '';
    late List<dynamic> data;
    double? balance = 0; 
    BigInt boughtCount = BigInt.zero;
    BigInt soldCount = BigInt.zero;
    int currentNftId = 0;
    HomePageModel();




  void initState(BuildContext context) {
    credential = EthPrivateKey.fromHex(privateKey);
    textFieldFocusNode = FocusNode();
    textController = TextEditingController();
    isExpanded = ExpandableController(initialExpanded: false);
    textControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    };
    //Create navBarModel 
    navBarModel = NavBar();
   // getMyNFTlist();
    //getNFTlist();
    //initializeMyaddress();
  }

  Future<void> initializeMyaddress() async {
    if (tempAddress != null) {
     myAddress = tempAddress.toString(); 
    }
  }

  Future<void> initializeContract() async {
    _httpClient = http.Client();
    _ethClient = Web3Client(blockchainUrl, _httpClient);
    _contract = await getContract();
  }

  Future<void> makeAuthorizedRequest() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(Uri.parse(blockchainUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response data: $responseData');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }


  //getters
  http.Client getHttpClient () => _httpClient;
  Web3Client getEthClient() => _ethClient;

  Future<DeployedContract> getContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0xBC47D353E93AE878Be44DE4cAdb04A551F3Eef0D";

    final contract = DeployedContract(ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<String> transaction(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await _ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: contract.function('constructor'),
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getContract();
    final function = contract.function(functionName);
    final result = await _ethClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

   Future<String> mintToken(String name, String description, String imageUrl, BigInt price) async {
    ContractFunction _mintFunction = _contract.function('mint');
    final result = await _ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: _contract,
        function: _mintFunction,
        parameters: [name, description, imageUrl, price],
      ),
      chainId: null, // Можете да зададете chainId, ако е необходимо
      fetchChainIdFromNetworkId: true,
    );
    return result;
  }

 Future<String> buyToken(int tokenId, int price) async {
    ContractFunction _buyTokenFunction = _contract.function('buyNFT');
    final result = await _ethClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: _contract,
        function: _buyTokenFunction,
        parameters: [BigInt.from(tokenId)],
        value: EtherAmount.inWei(BigInt.from(price)),
      ),
      chainId: null, // Можете да зададете chainId, ако е необходимо
      fetchChainIdFromNetworkId: true,
    );
    return result;
  }

  // Future<void> getCounts() async {
  //   ContractFunction _boughtCount = _contract.function('getBoughtCount');
  //   ContractFunction _soldCount = _contract.function('getSoldCount');

  //   final List<dynamic> boughtCountsResult = await _ethClient.call(
  //     contract: _contract,
  //     function: _boughtCount,
  //     params: [myAddress],
  //   );

  //   final List<dynamic> soldCountsResult = await _ethClient.call(
  //     contract: _contract,
  //     function: _soldCount,
  //     params: [myAddress],
  //   );
  //   try{
  //     setState(() {
  //       boughtCount = boughtCountsResult[0] as BigInt;
  //       soldCount = soldCountsResult[0] as BigInt;
  //     });
  //   }
  //     print("Error in getCounts: $error");
  //   }
  // }

  Future<void> getNFTlist() async {
    try {
      List<dynamic> result = await query("getAllNFTs", []);
      print('result length: ${result[0].length}');
      allNfts.clear();
      for (int i = 0; i < result[0].length; i++){
        allNfts.add(NFT.fromJsonList(result[0][i])); 
      };
      print('all: ${allNfts.length}');
    } catch (error) {
      print("Error fetching NFT list: $error");
    }
  }

  Future<void> getMyNFTlist() async {
    try {
      EthereumAddress args = EthereumAddress.fromHex(myAddress);
      List<dynamic> result = await query("getMyNFTs", [args]);
      print('result length: ${result[0].length}');
      myNfts.clear();
      for (int i = 0; i < result[0].length; i++){
        myNfts.add(NFT.fromJsonList(result[0][i])); 
      };
      print('my: ${myNfts.length}');
    } catch (error) {
      print("Error fetching myNFT list: $error");
    }
  }
  
  void logout() {
    //logout of the wallet account and go back to start hage
  

  }


  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    //navBarModel.dispose();
  }
  
}
