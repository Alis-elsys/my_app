import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:convert'; 
import '../components/NFT.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import '../models/home_page_model.dart';
//import 'package:walletconnect_flutter_v2/apis/core/relay_client/json_rpc_2/src/client.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

import '../components/nav_bar.dart';
import '../components/NFT_card.dart';
import 'info_page.dart';
import 'my_nft_page.dart';
export 'home_page.dart';

class HomePageWidget extends StatefulWidget {
  //final List<NFT> nfts;
    late HomePageModel model;
//
   HomePageWidget();

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = '';
 
  late Client httpClient;
  late Web3Client ethClient;
  List<dynamic> data = [];
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();
 
  int balance = 0;
  String title = "";
  int count = 0;
  int length = 0;
  NFT nft = NFT(
    tokenId: BigInt.zero,
    name: '',
    description: '',
    imageUrl: '',
    price: BigInt.zero,
    owner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')
  );


  Future<DeployedContract> getContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x0C5186Ba7eCda919Db737946C4cfF9A5d5EF1786";
    //widget.model from HomePageWidget
    
    final contract = DeployedContract(ContractAbi.fromJson(abi, widget.model.contractName),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await widget.model.getContract();
    final function = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: function, params: args);
    return result;
  }
  
  

  Future<void> getMyNFTlist() async {
   try{
      EthereumAddress args = EthereumAddress.fromHex(widget.model.myAddress);
      List<dynamic> result = await widget.model.query("getMyNFTs", [args]);
      setState(() {
        for (int i = 0; i < result[0].length; i++){
          widget.model.myNfts.add(NFT.fromJsonList(result[0][i]));
        }
      });
    } catch (e) {
      print('Error in getMyNFT(): $e');
    }
  }

  Future<void> getNFT(BigInt id) async {
    try{
      List<dynamic> result = await widget.model.query("getNFT", [id]);
      setState(() {
        nft = NFT.fromJsonList(result[0]);
      });
    } catch (e) {
      print('Error in getNFT(): $e');
    }
  }

  Future<void> getCounter() async {
    List<dynamic> result = await widget.model.query("getCounter", []);
    setState(() {
      count = int.parse(result[0].toString());
    });
  }

  Future<void> getLenght() async {
    try{
      EthereumAddress args = EthereumAddress.fromHex(widget.model.myAddress);
      List<dynamic> result = await widget.model.query("getLenght", [args]);
      setState(() { 
        length = int.parse(result[0].toString());
      });
    } catch (e) {
      print('Error in getLenght: $e');
    }
  }

  Future<void> refreshData(String targetAddress) async {
    await widget.model.getNFTlist();
    //await getNFT(BigInt.one);
    await getCounter();
    await getLenght();
  }


  @override
  void initState() {
    super.initState();
    widget.model = HomePageModel();
    widget.model.initState(context);
    widget.model.initializeContract();
    ethClient = widget.model.getEthClient();
    //widget.model.initializeMyaddress();
    //fetch data from nft.dart and put it in allNFTs
    getLenght();   
    widget.model.getNFTlist();
    //allNFTs = getMyNFTlist() as List<NFT>;
    getNFT(BigInt.one);
    getMyNFTlist();
    //fetchData();
    getCounter();  
  }


  @override
  void dispose() {
    widget.model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //if there is a previous page go to it
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: TextFormField(
                      controller: widget.model.textController,
                      focusNode: widget.model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        alignLabelWithHint: false,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffe0e3e7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xff4b39ef),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffff5963),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xffff5963),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // validator:
                      //     widget.model.textControllerValidator(context, widget.model.textController?.text),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                  icon: const Icon(
                    Icons.search_sharp,
                    color: Color.fromARGB(255, 35, 61, 105),
                    size: 24,
                  ),
                  style: ButtonStyle(
                    side: const MaterialStatePropertyAll(
                        BorderSide(color: Colors.black87, width: 1)),
                    fixedSize:
                        const MaterialStatePropertyAll(Size.fromWidth(40)),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.indigo.shade200),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Colors.black87, width: 1))),
                    elevation: const MaterialStatePropertyAll(0),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: ListView.builder(
                  itemCount: widget.model.allNfts.length,
                  itemBuilder: (context, index) => productCard(
                    imageUrl: widget.model.allNfts[index].imageUrl,
                    productName: widget.model.allNfts[index].name,
                    price: widget.model.allNfts[index].price,
                    id: widget.model.allNfts[index].tokenId,
                    context: context,
                    onPressed: (){
                      try{
                        int currentNftId = int.parse(widget.model.allNfts[index].tokenId.toString());
                        print("NFT id if the clicked : ${currentNftId}");
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => InfoPageWidget(currentNftId: currentNftId),
                          ),
                        );
                        print("button pushed");
                      }catch(e){
                        print("navigating to info $e");
                      }
                    },
                  ),
                )
              )
            ),
         
          
          ],
        ),
      ),
      bottomNavigationBar: NavBar()
    );
    
  }
}
