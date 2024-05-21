import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'models/home_page_model.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:walletconnect_flutter_dapp/widgets/session_widget.dart';
import 'package:walletconnect_flutter_dapp/utils/dart_defines.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    super.key,
    required this.swapTheme,
    required this.changeTheme,
  });
  final VoidCallback swapTheme;
  final VoidCallback changeTheme;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late W3MService _w3mService;
  bool _initialized = false;
  late HomePageModel _model;

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initializeContract();
    
    _initializeService();
  }

  void _initializeService() async {
    _w3mService = W3MService(
      projectId: DartDefines.projectId,
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: StringConstants.startPageTitle,
        description: StringConstants.startPageTitle,
        url: 'https://www.walletconnect.com/',
        icons: ['https://web3modal.com/images/rpc-illustration.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();

    _w3mService.addListener(_serviceListener);
    _w3mService.web3App?.onSessionEvent.subscribe(_onSessionEvent);
    _w3mService.web3App?.onSessionConnect.subscribe(_onSessionConnect);
    _w3mService.web3App?.onSessionDelete.subscribe(_onSessionDelete);

    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _w3mService.web3App?.onSessionEvent.unsubscribe(_onSessionEvent);
    _w3mService.web3App?.onSessionConnect.unsubscribe(_onSessionConnect);
    _w3mService.web3App?.onSessionDelete.unsubscribe(_onSessionDelete);
    super.dispose();
  }

  void _serviceListener() {
    setState(() {});
  }

  void _onSessionEvent(SessionEvent? args) {
    debugPrint('[$runtimeType] _onSessionEvent $args');
  }

  void _onSessionConnect(SessionConnect? args) {
    debugPrint('[$runtimeType] _onSessionConnect $args');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageWidget(),
      ),
    );
  }

  void _onSessionDelete(SessionDelete? args) {
    debugPrint('[$runtimeType] _onSessionDelete $args');
  }

  bool _isSessionRunning() {
    //see if the runtime of the session is >0
    return _w3mService.web3App?.runtimeType == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final isSquare = Web3ModalTheme.radiusesOf(context).isSquare();
    final isCircular = Web3ModalTheme.radiusesOf(context).isCircular();
        if (!_initialized) {
          return Center(
            child: CircularProgressIndicator(
              color: Web3ModalTheme.colorsOf(context).accent100,
            ),
          );
        }
        //if is connected and if session is running
        if(_w3mService.isConnected & _isSessionRunning()){
          //save the address of the connected wallet
          //_model.initializeMyaddress();
          return HomePageWidget();
        }
        return Scaffold(
      backgroundColor: Web3ModalTheme.colorsOf(context).background300,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(StringConstants.startPageTitle),
        backgroundColor: Web3ModalTheme.colorsOf(context).background100,
        foregroundColor: Web3ModalTheme.colorsOf(context).foreground100
        ),
        body: Column(children: [
          IconButton(
            icon: isSquare || isCircular
                ? const Icon(Icons.yard)
                : const Icon(Icons.yard_outlined),
            onPressed: widget.changeTheme,
          ),
          IconButton(
            icon: Web3ModalTheme.maybeOf(context)?.isDarkMode ?? false
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
            onPressed: widget.swapTheme,
          )
        ],)
        
      
        // final isCustom = Web3ModalTheme.isCustomTheme(context);
        // return SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       Text('Custom theme is: ${isCustom ? 'ON' : 'OFF'}'),
        //       _ButtonsView(w3mService: _w3mService),
        //       const Divider(height: 0.0),
        //       //_ConnectedView(w3mService: _w3mService)
        //     ],
        //   ),
        // );
      );
  }
}

class _ButtonsView extends StatelessWidget {
  const _ButtonsView({required this.w3mService});
  final W3MService w3mService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox.square(dimension: 8.0),
        Visibility(
          visible: !w3mService.isConnected,
          child: W3MNetworkSelectButton(service: w3mService),
        ),
        W3MConnectWalletButton(service: w3mService),
        const SizedBox.square(dimension: 8.0),
      ],
    );
  }
}

class _ConnectedView extends StatelessWidget {
  const _ConnectedView({required this.w3mService});
  final W3MService w3mService;

  @override
  Widget build(BuildContext context) {
    if (!w3mService.isConnected) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox.square(dimension: 12.0),
        W3MAccountButton(service: w3mService),
        SessionWidget(
          w3mService: w3mService,
          launchRedirect: () {
            w3mService.launchConnectedWallet();
          },
        ),
        const SizedBox.square(dimension: 12.0),
      ],
    );
  }
}

final _exampleCustomChain = W3MChainInfo(
  chainName: 'Celo',
  namespace: 'eip155:42220',
  chainId: '42220',
  tokenName: 'CELO',
  rpcUrl: 'https://forno.celo.org/',
  blockExplorer: W3MBlockExplorer(
    name: 'Celo Explorer',
    url: 'https://explorer.celo.org/mainnet',
  ),
);