// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/rendering.dart';

// import 'components/NFT.dart';
// import 'package:http/http.dart';
// import 'package:flutter/material.dart';
// import 'package:walletconnect_flutter_dapp/models/home_page2_model.dart';
// //import 'package:walletconnect_flutter_v2/apis/core/relay_client/json_rpc_2/src/client.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:http/src/client.dart';
// import 'package:flutter/services.dart';

// import '../components/nav_bar.dart';
// import '../components/NFT_card.dart';
// import 'package:flutter/scheduler.dart';
// import 'main.dart';
// import 'start_page.dart';
// import 'home_page.dart';
// export 'home_page.dart';

// class HomePageWidget extends StatefulWidget {
//   //final List<NFT> nfts;

//   const HomePageWidget({super.key});

//   @override
//   State<HomePageWidget> createState() => _HomePageWidgetState();
// }

// class _HomePageWidgetState extends State<HomePageWidget> {
//   late HomePageModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   String name = '';
//   // String _url = "HTTP://127.0.0.1:7545";
// //String _wsUrl = "ws://127.0.0.1:7545/";

//   late Client httpClient;
//   late Web3Client ethClient;
//   TextEditingController controllerAmount = TextEditingController();
//   TextEditingController controllerTitle = TextEditingController();
//   // Ethereum address
//   final String myAddress = "0x5e5386C139c5A9F9d99a743Ff10647b140AB543c";
//   // my "0x5e5386C139c5A9F9d99a743Ff10647b140AB543c";
//   // URL from Infura
//   final String blockchainUrl =
//       "https://sepolia.infura.io/v3/7f0484b1a988417e9be1706dd241a9fd";

//   //"https://rinkeby.infura.io/v3/4e577288c5b24f17a04beab17cf9c959";

//   String contractName = "Fluthereum";
//   String privateKey =
//       "5e0b7dd43a57934770bb8e7d563d26cc94f4c9cb4ec04c72e20cf1bee4cd66c3";
//   //  my  "5e0b7dd43a57934770bb8e7d563d26cc94f4c9cb4ec04c72e20cf1bee4cd66c3";

//   int balance = 0;
//   String title = "";
//   int length = -1;
//   NFT nft = NFT(
//     tokenId: BigInt.from(0),
//     name: '',
//     description: '',
//     imageUrl: '',
//     price: 0,
//     owner: EthereumAddress.fromHex("0x0"),
//   );
//   /*maka a list of NFTs he struct is that struct NFT{
//         uint256 id;
//         string name;
//         address payable NFTowner;
//         string imageUrl; 
//         uint256 price;
//     }
// */

// //make a struct or class for NFTs

//   List<NFT> allNFTs = [];
//   bool loading = false;
//   //int amount = 0;

//   Future<String> transaction(String functionName, List<dynamic> args) async {
//     EthPrivateKey credential = EthPrivateKey.fromHex(privateKey);
//     DeployedContract contract = await getContract();
//     ContractFunction function = contract.function(functionName);
//     dynamic result = await ethClient.sendTransaction(
//       credential,
//       Transaction.callContract(
//         contract: contract,
//         function: contract.function('constructor'),
//         parameters: args,
//       ),
//       fetchChainIdFromNetworkId: true,
//       chainId: null,
//     );

//     return result;
//   }

//   Future<DeployedContract> getContract() async {
//     String abi = await rootBundle.loadString("assets/abi.json");
//     String contractAddress = "0x0C5186Ba7eCda919Db737946C4cfF9A5d5EF1786";

//     final contract = DeployedContract(ContractAbi.fromJson(abi, contractName),
//         EthereumAddress.fromHex(contractAddress));

//     return contract;
//   }

//   Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
//     final contract = await getContract();
//     final function = contract.function(functionName);
//     final result = await ethClient.call(
//         contract: contract, function: function, params: args);
//     return result;
//   }

//   Future<void> getBalance(String targetAddress) async {
//     List<dynamic> result = await query("getBalance", []);
//     balance = int.parse(result[0].toString());
//     setState(() {});
//     loading = true;
//   }

//   Future<void> getTitle(String targetAddress) async {
//     List<dynamic> result = await query("getTitle", []);
//     title = result[0];
//     setState(() {});
//     loading = true;
//   }

//   Future<void> getNFTlist() async {
//     List<dynamic> result = await query("getAllNFTs", []);

//     allNFTs = result.map((e) => NFT.fromJson(e)).toList();
//     setState(() {});
//     loading = true;

//     print("/n allNFTs count: ${allNFTs.length}");
//   }

//   Future<void> getNFT(int id) async {
//     List<dynamic> result = await query("getNFT", [BigInt.from(id)]);
//     nft = result[0].map((e) => NFT.fromJson(e));
//     setState(() {});
//     loading = true;
//   }

//   Future<void> getLenght() async {
//     List<dynamic> result = await query("getLength", []);
//     length = int.parse(result[0].toString());
//     setState(() {});
//     loading = true;
//   }

//   Future<void> getCount(String targetAddress) async {
//     List<dynamic> result = await query("getCounter", []);
//     length = result[0];
//     setState(() {});
//     loading = true;
//   }

//   Future<void> refreshData(String targetAddress) async {
//     getBalance(targetAddress);
//     getTitle(targetAddress);
//     print("refreshed");
//   }

//   Future<void> deposit(int amount) async {
//     BigInt parsedAmount = BigInt.from(amount);
//     var result = await transaction("deposit", [parsedAmount]);
//     print("deposited");
//     print(result);
//   }

//   Future<void> withdraw(int amount) async {
//     BigInt parsedAmount = BigInt.from(amount);
//     var result = await transaction("withdraw", [parsedAmount]);
//     print("withdraw done");
//     print(result);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _model = HomePageModel();
//     _model.initState(context);
//     httpClient = Client();
//     ethClient = Web3Client(blockchainUrl, httpClient);
//     //fetch data from nft.dart and put it in allNFTs
//     getCount(myAddress);     
//     getNFTlist();
//     getNFT(0);
//     getBalance(myAddress);
//     getTitle(myAddress);

//   }

//   // Future <void> getAllNFTs() async {
//   //   List<dynamic> result = await ethClient.call(
//   //       contract: ethClient,
//   //       function: ethClient.function("getAllNFTs"),
//   //       params: []);
//   // }

//   void nameF() {
//     String name = 'name';
//     List<ContractFunction> functions = [];
//     List<ContractEvent> events = [];
//     ContractAbi contract = ContractAbi(name, functions, events);
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Color(0xFff1F4F8),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFF1F4F8),
//         elevation: 10.0,
//         title: const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
//               child: Text(
//                 'Home',
//                 style: TextStyle(
//                   fontFamily: 'Plus Jakarta Sans',
//                   color: Color(0xFF101213),
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             // Add any additional widgets or actions here
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
//                   child: Container(
//                     width: MediaQuery.sizeOf(context).width * 0.4,
//                     child: TextFormField(
//                       controller: _model.textController,
//                       focusNode: _model.textFieldFocusNode,
//                       autofocus: false,
//                       obscureText: false,
//                       decoration: InputDecoration(
//                         labelText: 'Search',
//                         labelStyle: Theme.of(context).textTheme.bodyMedium,
//                         alignLabelWithHint: false,
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Color(0xffe0e3e7),
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Color(0xff4b39ef),
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         errorBorder: UnderlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Color(0xffff5963),
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedErrorBorder: UnderlineInputBorder(
//                           borderSide: const BorderSide(
//                             color: Color(0xffff5963),
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       // validator:
//                       //     _model.textControllerValidator(context, _model.textController?.text),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     print('IconButton pressed ...');
//                   },
//                   icon: const Icon(
//                     Icons.search_sharp,
//                     color: Color.fromARGB(255, 35, 61, 105),
//                     size: 24,
//                   ),
//                   style: ButtonStyle(
//                     side: const MaterialStatePropertyAll(
//                         BorderSide(color: Colors.black87, width: 1)),
//                     fixedSize:
//                         const MaterialStatePropertyAll(Size.fromWidth(40)),
//                     backgroundColor:
//                         MaterialStatePropertyAll(Colors.indigo.shade200),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             side: const BorderSide(
//                                 color: Colors.black87, width: 1))),
//                     elevation: const MaterialStatePropertyAll(0),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               "${allNFTs.length} NFTs available",
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 color: Color(0xFF101213),
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 child: ListView(
//                   children: [
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: allNFTs.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                       ),
//                       itemBuilder: (context, index) => productCard(
//                         id: allNFTs[index].tokenId,
//                         imageUrl: allNFTs[index].imageUrl,
//                         productName: allNFTs[index].name,
//                         price: "\$${allNFTs[index].price.toString()}",
//                       ),
//                     ),
//                   ]
//                 ),
//               ),
//             ),
//             Text(
//               '${nft.tokenId}',
//               style: TextStyle(
//                 fontFamily: 'Plus Jakarta Sans',
//                 color: Color(0xFF101213),
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             productCard(
//               id: nft.tokenId,
//               imageUrl: nft.imageUrl,
//               productName: nft.name,
//               price: "\$${nft.price.toString()}",
//             ),
         
          
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomNavBar()
//     );
//   }
// }