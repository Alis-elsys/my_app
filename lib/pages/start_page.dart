import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
//import 'package:flutter_web3/flutter_web3.dart';
import 'package:walletconnect_flutter_dapp/widgets/session_widget.dart';
import 'package:walletconnect_flutter_dapp/utils/dart_defines.dart';
import 'package:walletconnect_flutter_dapp/utils/string_constants.dart';
import '../models/home_page_model.dart';


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

  final HomePageModel model = HomePageModel();
  String currentAddress = '';
  int currentChain = 0;
  @override
  void initState() {
    super.initState();

    if (_initialized) {
      _initialized = false;
    }
    _initializeService();
    _w3mService.disconnect();

    model.initState(context);
  }

  void _initializeService() async {
    //if already initialized, return and navigate to home page

    W3MChainPresets.chains.putIfAbsent('42220', () => _exampleCustomChain);

    _w3mService = W3MService(
      projectId: '0cd51c297a6258e0049368383fcd44e7',
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
    if (mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageWidget(),
      ),
    );
  }
  }

  void _onSessionDelete(SessionDelete? args) {
    debugPrint('[$runtimeType] _onSessionDelete $args');
  }

  @override
  Widget build(BuildContext context) {
    final isSquare = Web3ModalTheme.radiusesOf(context).isSquare();
    final isCircular = Web3ModalTheme.radiusesOf(context).isCircular();
    return Scaffold(
      backgroundColor: Web3ModalTheme.colorsOf(context).background300,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(StringConstants.startPageTitle),
        backgroundColor: Web3ModalTheme.colorsOf(context).background100,
        foregroundColor: Web3ModalTheme.colorsOf(context).foreground100,
        actions: [
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
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (!_initialized) {
          return Center(
            child: CircularProgressIndicator(
              color: Web3ModalTheme.colorsOf(context).accent100,
            ),
          );
        }
        final isCustom = Web3ModalTheme.isCustomTheme(context);
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Custom theme is: ${isCustom ? 'ON' : 'OFF'}'),
              _ButtonsView(w3mService: _w3mService),
              const Divider(height: 0.0),
              _ConnectedView(w3mService: _w3mService, model: model)
            ],
          ),
        );
      }),
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
  _ConnectedView({required this.w3mService, required this.model});
  final W3MService w3mService;  
  final HomePageModel model;

  @override
  Widget build(BuildContext context) {

    if (!w3mService.isConnected) {
      return const SizedBox.shrink();
    }else{
      model.tempAddress = w3mService.address;
      model.balance = w3mService.chainBalance;
    }

      WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (w3mService.isConnected) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageWidget(),
          ),
        );
      }
    });

    return const SizedBox.shrink();
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