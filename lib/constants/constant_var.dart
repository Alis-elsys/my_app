//save the varuable that are constant



// Path: example/lib/constants/constant_var.dart
// Compare this snippet from example/lib/models/home_page_model.dart:

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:walletconnect_flutter_dapp/utils/dart_defines.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';

import '../components/NFT.dart';
import '../components/nav_bar.dart';

class Variables{
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  ExpandableController? isExpanded;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for NavBar1 component.
  late NavBar navBarModel;
  List<NFT> allNfts = [];
  late Client _httpClient;
    late Web3Client _ethClient;
    late DeployedContract _contract;
    late EthereumAddress address;
    final String blockchainUrl =
      "https://sepolia.infura.io/v3/7f0484b1a988417e9be1706dd241a9fd"; //Endpoint for the blockchain
    final String apiKey = "FdTLCM20fELyB/28wtHUxbnRuicnICMQl1tC2ejUQzWUuYh2vGabFQ";
    String contractName = "Fluthereum";
    late String contractAddress;
    String privateKey =
    "5e0b7dd43a57934770bb8e7d563d26cc94f4c9cb4ec04c72e20cf1bee4cd66c3";
    late String myAddress;
    late int currentNftId;
    late List<dynamic> data;
}