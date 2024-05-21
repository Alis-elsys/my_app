import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import '../models/home_page_model.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({Key? key}) : super(key: key);

  @override
  State<SettingsPageWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageWidget> {
  late HomePageModel _model;
  late String privateKey;
  late String myAddress;
  bool loading = false;
  TextEditingController controllerPrivateKey = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Private Key',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: controllerPrivateKey,
              decoration: const InputDecoration(
                hintText: 'Enter your private key',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'My Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: controllerAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                // await _model.setPrivateKey(controllerPrivateKey.text);
                // await _model.setMyAddress(controllerAddress.text);
                setState(() {
                  loading = false;
                });
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      _model.logout();
                    },
                    child: const Text('Logout'),
                  ),
          ],
        ),
      ),
    );
  }
}