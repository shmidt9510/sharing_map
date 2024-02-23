import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;
  static late FlutterSecureStorage _secureSharedPref;
  static final SharedPrefs _instance = SharedPrefs._internal();
  static final _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _secureSharedPref = FlutterSecureStorage();
  }

  String get userId => _sharedPrefs.getString(keyUserId) ?? "";

  set userId(String value) {
    _sharedPrefs.setString(keyUserId, value);
  }

  bool get logged => _sharedPrefs.getBool(keyIsLogged) ?? false;

  set logged(bool value) {
    _sharedPrefs.setBool(keyIsLogged, value);
  }

  Future<String> getAuthToken() async =>
      await _secureSharedPref.read(
          key: keyAuthToken, aOptions: _androidOptions) ??
      "";

  set authToken(String value) {
    _secureSharedPref.write(
        key: keyAuthToken, value: value, aOptions: _androidOptions);
  }

  Future<String> getRefreshToken() async =>
      await _secureSharedPref.read(
          key: keyRefreshToken, aOptions: _androidOptions) ??
      "";

  set refreshToken(String value) {
    _secureSharedPref.write(
        key: keyRefreshToken, value: value, aOptions: _androidOptions);
  }

  String get confirmationToken =>
      _sharedPrefs.getString(keyConfirmationToken) ?? "";

  set confirmationToken(String value) {
    _sharedPrefs.setString(keyConfirmationToken, value);
  }

  Future<void> clear() async {
    await _sharedPrefs.clear();
  }

  bool get isFirstRun => _sharedPrefs.getBool(keyIsFirst) ?? true;

  set isFirstRun(bool value) {
    _sharedPrefs.setBool(keyIsFirst, value);
  }

  String get resetPasswordToken =>
      _sharedPrefs.getString(keyResetPasswordToken) ?? "";

  set resetPasswordToken(String value) {
    _sharedPrefs.setString(keyResetPasswordToken, value);
  }

  int get counter => _sharedPrefs.getInt("counter") ?? 0;
  set counter(int value) {
    _sharedPrefs.setInt("counter", value);
  }
}
// String get isLogged => _sharedPrefs!.getString(keyUsername) ?? "";

//   set username(String value) {
//     _sharedPrefs!.setString(keyUsername, value);
//   }

final sharedPrefs = SharedPrefs();

const String keyUserId = "key_userId";
const String keyIsLogged = "is_logged";
const String keyIsFirst = "first_start";
const String keyAuthToken = "key_auth_token";
const String keyRefreshToken = "refresh_token";
const String keyConfirmationToken = "confirmation_token";
const String keyResetPasswordToken = "reset_password_token";
