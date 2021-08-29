import 'dart:core';
import 'package:istreamo/constants.dart';
import 'package:local_auth/local_auth.dart';

class BiometricApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometric() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<BiometricStatus> authenticate() async {
    final isAvailable = await hasBiometric();
    if (!isAvailable) return BiometricStatus.NO_SENSOR;
    try {
      bool res = await _auth.authenticate(
        localizedReason: 'Fingerprint for authentication',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      if (res) {
        return BiometricStatus.VALID;
      } else {
        return BiometricStatus.INVALID;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return BiometricStatus.INVALID;
    }
  }
}
