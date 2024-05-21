import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'pages/start_page.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/src/client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart';
import 'components/NFT.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isDarkMode = false;
  Web3ModalThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        final platformDispatcher = View.of(context).platformDispatcher;
        final platformBrightness = platformDispatcher.platformBrightness;
        _isDarkMode = platformBrightness == Brightness.dark;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    //List<NFT> nfts = fetchNFTData();
    return Web3ModalTheme(
      isDarkMode: _isDarkMode,
      themeData: _themeData,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringConstants.startPageTitle,
        home: StartPage(
          swapTheme: () => _swapTheme(),
          changeTheme: () => _changeTheme(),
        ),
      ),
    );
  }

  // List<NFT>  () {
  //   // Simulated data for demonstration purposes
  //   return [
  //     NFT(tokenId: 1, name: 'NFT 1', description: 'Description 1', imageUrl: 'https://example.com/nft1.jpg'),
  //     NFT(tokenId: 2, name: 'NFT 2', description: 'Description 2', imageUrl: 'https://example.com/nft2.jpg'),
  //   ];
  // }
  
  
    void _swapTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _changeTheme() {
    setState(() {
      _themeData = (_themeData == null)
          ? Web3ModalThemeData(
              lightColors: Web3ModalColors.lightMode.copyWith(
                accent100: Colors.red,
                background100: const Color.fromARGB(255, 187, 234, 255),
                background125: const Color.fromARGB(255, 187, 234, 255),
              ),
              darkColors: Web3ModalColors.darkMode.copyWith(
                accent100: Colors.orange,
                background100: const Color.fromARGB(255, 36, 0, 120),
                background125: const Color.fromARGB(255, 36, 0, 120),
              ),
              radiuses: Web3ModalRadiuses.circular,
            )
          : null;
    });
  }
}
