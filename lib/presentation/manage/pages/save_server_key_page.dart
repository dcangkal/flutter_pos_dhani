import 'package:flutter/material.dart';
import 'package:flutter_pos_dhani/core/constants/colors.dart';

import '../../../data/datasources/auth_local_datasource.dart';

class SaveServerKeyPage extends StatefulWidget {
  const SaveServerKeyPage({super.key});

  @override
  State<SaveServerKeyPage> createState() => _SaveServerKeyPageState();
}

class _SaveServerKeyPageState extends State<SaveServerKeyPage> {
  TextEditingController? serverKeyController;

  String serverKey = '';

  Future<void> getServerKey() async {
    serverKey = await AuthLocalDatasource().getMitransServerKey();
  }

  @override
  void initState() {
    super.initState();
    serverKeyController = TextEditingController();
    getServerKey();
    //delay 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      serverKeyController!.text = serverKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans ServerKey'),
        centerTitle: true,
      ),
      //textfield untuk input server key
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: serverKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Key',
              ),
            ),
          ),
          //button untuk save server key
          ElevatedButton(
            onPressed: () {
              AuthLocalDatasource()
                  .saveMidtransServerKey(serverKeyController!.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.primary,
                  content: Text('Server Key saved'),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<void>(
            future: getServerKey(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If data is still loading
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurred
                return Text('Error: ${snapshot.error}');
              } else {
                // If data is available, display the server key
                return Text(serverKey);
              }
            },
          ),
        ],
      ),
    );
  }
}
