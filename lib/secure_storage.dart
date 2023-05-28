import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// For accessing, storing and retreiving user data from secure storage.
class SecureStorage {
  static const storage = FlutterSecureStorage();

  static Future<void> setUsername(String value) {
    return setSecureStorageValue('username', value);
  }

  static Future<String> getUsername() async {
    return getSecureStorageValue('username');
  }

  static Future<void> setPassword(String value) async {
    return setSecureStorageValue('password', value);
  }

  static Future<String> getPassword() {
    return getSecureStorageValue('password');
  }

  static Future<void> setUserData(String value) async {
    return setSecureStorageValue('userData', value);
  }

  static Future<String> getUserData() {
    return getSecureStorageValue('userData');
  }

  static Future<void> setSecureStorageValue(String key, String value) {
    return storage.write(key: key, value: value);
  }

  static Future<String> getSecureStorageValue(String key) async {
    return await storage.read(key: key) ?? "";
  }
}
