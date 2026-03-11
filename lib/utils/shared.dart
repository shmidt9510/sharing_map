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

  Future<void> setLoggedAsync(bool value) async {
    await _sharedPrefs.setBool(keyIsLogged, value);
  }

  Future<String> getAuthToken() async {
    try {
      var token = await _secureSharedPref.read(
          key: keyAuthToken, aOptions: _androidOptions);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}
    return _sharedPrefs.getString(keyAuthToken) ?? "";
  }

  set authToken(String value) {
    _secureSharedPref
        .write(key: keyAuthToken, value: value, aOptions: _androidOptions)
        .catchError((_) {});
    _sharedPrefs.setString(keyAuthToken, value);
  }

  Future<void> setAuthTokenAsync(String value) async {
    try {
      await _secureSharedPref.write(
          key: keyAuthToken, value: value, aOptions: _androidOptions);
    } catch (_) {}
    await _sharedPrefs.setString(keyAuthToken, value);
  }

  Future<String> getRefreshToken() async {
    try {
      var token = await _secureSharedPref.read(
          key: keyRefreshToken, aOptions: _androidOptions);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}
    return _sharedPrefs.getString(keyRefreshToken) ?? "";
  }

  set refreshToken(String value) {
    _secureSharedPref
        .write(key: keyRefreshToken, value: value, aOptions: _androidOptions)
        .catchError((_) {});
    _sharedPrefs.setString(keyRefreshToken, value);
  }

  Future<void> setRefreshTokenAsync(String value) async {
    try {
      await _secureSharedPref.write(
          key: keyRefreshToken, value: value, aOptions: _androidOptions);
    } catch (_) {}
    await _sharedPrefs.setString(keyRefreshToken, value);
  }

  String get confirmationToken =>
      _sharedPrefs.getString(keyConfirmationToken) ?? "";

  set confirmationToken(String value) {
    _sharedPrefs.setString(keyConfirmationToken, value);
  }

  Future<void> setUserIdAsync(String value) async {
    await _sharedPrefs.setString(keyUserId, value);
  }

  Future<void> clear() async {
    try {
      await _secureSharedPref.deleteAll();
    } catch (_) {}
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

  int get chosenCity => _sharedPrefs.getInt(keyChosenCity) ?? -1;
  set chosenCity(int value) {
    _sharedPrefs.setInt(keyChosenCity, value);
  }

  bool get configInit => _sharedPrefs.getBool(keyConfigInit) ?? false;
  set configInit(bool value) {
    _sharedPrefs.setBool(keyConfigInit, value);
  }

  String get initPath => _sharedPrefs.getString(keyInitPath) ?? "";
  set initPath(String value) {
    _sharedPrefs.setString(keyInitPath, value);
  }
}

final sharedPrefs = SharedPrefs();

const String keyUserId = "key_userId";
const String keyIsLogged = "is_logged";
const String keyIsFirst = "first_start";
const String keyAuthToken = "key_auth_token";
const String keyRefreshToken = "refresh_token";
const String keyConfirmationToken = "confirmation_token";
const String keyResetPasswordToken = "reset_password_token";
const String keyChosenCity = "chosen_city";
const String keyConfigInit = "config_init";
const String keyInitPath = "init_path";
