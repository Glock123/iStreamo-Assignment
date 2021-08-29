import 'package:flutter/material.dart';
import 'package:istreamo/api/biometric_api.dart';

import '../constants.dart';
import 'home.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void printSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            BiometricStatus currentStatus = await BiometricApi.authenticate();
            if (currentStatus == BiometricStatus.INVALID) {
              printSnackBar(
                context: context,
                message: 'Invalid biometric',
                color: Colors.red,
              );
            } else if (currentStatus == BiometricStatus.VALID) {
              printSnackBar(
                context: context,
                message: 'Correct biometric!',
                color: Colors.green,
              );
              // Go to main screen
              // Navigator.of(context).pushReplacementNamed('home');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()),
              );
            } else {
              printSnackBar(
                  context: context,
                  message: 'No Biometric sensor found on device',
                  color: Colors.red);
            }
          },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Tap to authenticate!'),
        ),
      ),
    );
  }
}
