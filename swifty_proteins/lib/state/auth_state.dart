import 'package:flutter/foundation.dart';
import '../services/auth/account_store.dart';
import '../services/auth/biometric_service.dart';

// the states files serve to save all the screen info of a page = when these infos change, the screen must be re-drawn entirely (flutter doesn't update seperate elements on the page, the whole page)

// this state tracks if the user is loggen in or not and notifies the root app widget on which login state the app is now

// here, we need 2 states : 
enum AuthStatus { loggedOut, loggedIn }

class AuthState extends ChangeNotifier {
  final AccountStore _accountStore = AccountStore();
  final BiometricService _biometricService = BiometricService();

  AuthStatus status = AuthStatus.loggedOut; // save the current status, by default logged out
  String? lastError; // save the last login error

  Future<bool> register(String username, String password) async {
    final created = await _accountStore.register(username, password);
    lastError = created ? null : 'This username is already taken by another user';
    notifyListeners(); // update the screen (we hav a new register)
    return created;
  }

  Future<bool> login(String username, String password) async {
    final valid = await _accountStore.validateLogin(username, password);
    if (valid) {
      status = AuthStatus.loggedIn;
      lastError = null;
    } else {
      lastError = 'Incorrect username or password';
    }
    notifyListeners();
    return valid;
  }

  Future<bool> loginWithBiometrics() async {
    if (!await _accountStore.hasAnyAccount()) {
      lastError = 'Please create an account first.';
      notifyListeners();
      return false;
    }

    final failureMessage = await _biometricService.authenticate();
    final success = failureMessage == null;
    if (success) {
      status = AuthStatus.loggedIn;
    }
    lastError = failureMessage;
    notifyListeners();
    return success;
  }

  Future<bool> biometricsAvailable() {
    return _biometricService.isAvailable();
  }

  void logout() {
    status = AuthStatus.loggedOut;
    notifyListeners();
  }
}
