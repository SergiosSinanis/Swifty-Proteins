import 'dart:isolate';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// This service creates and checks user accounts using the "flutter_secure_storage" = it's encrypted (backed by Keychain on iOS)

class AccountStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(); // create a secure object to store the username as the key and the bcrypt hash of the password as the value
  static const String _passwordKeyPrefix = 'password_hash_for_'; // name format prefix for the keys

  Future<bool> register(String username, String password) async {
    final key = '$_passwordKeyPrefix$username'; // create a unique storage key using the username
    final existing = await _storage.read(key: key); // if this key exists already, stop
    if (existing != null) {
      return false;
    }
    // hash the key on a new thread
    final hash = await Isolate.run(() => BCrypt.hashpw(password, BCrypt.gensalt())); // bcrypt is slow on purpose, so not on the UI thread
    await _storage.write(key: key, value: hash); // save the hash in the secure object (not the password)
    return true;
  }

  Future<bool> validateLogin(String username, String password) async {
    final key = '$_passwordKeyPrefix$username';
    final storedHash = await _storage.read(key: key);
    if (storedHash == null)
      return false;
    // check in a new thread if the entered password matches the saved hash
    return Isolate.run(() => BCrypt.checkpw(password, storedHash));
  }

  // method to check if any account is created 
  Future<bool> hasAnyAccount() async {
    final all = await _storage.readAll();
    return all.keys.any((key) => key.startsWith(_passwordKeyPrefix));
  }
}
