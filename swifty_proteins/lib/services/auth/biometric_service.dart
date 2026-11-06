import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

// this wraps the "local_auth" package = it checks whether biometrics are available on this device, and triggers the system Face ID/Touch ID prompt

// iOS needs NSFaceIDUsageDescription in Info.plist, or this will fail at the platform level

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication(); // package:local_auth

  Future<bool> isAvailable() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      final enrolled = await _auth.getAvailableBiometrics();
      return isDeviceSupported && enrolled.isNotEmpty;
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  // returns null on success, otherwise the message explaining the failure
  Future<String?> authenticate() async {
    try {
      final success = await _auth.authenticate(
        localizedReason: 'Authenticate to access Swifty Protein',
        biometricOnly: true,
      );
      return success ? null : 'Authentication failed. Please try again.';
    } on LocalAuthException catch (error) {
      switch (error.code) {
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          return 'Too many failed attempts. Please log in with your password.';
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
          return 'Authentication was canceled.';
        case LocalAuthExceptionCode.noBiometricsEnrolled:
          return 'No biometrics are set up on this device.';
        default:
          return 'Authentication failed. Please try again.';
      }
    } on PlatformException {
      return 'Authentication failed. Please try again.';
    }
  }
}
