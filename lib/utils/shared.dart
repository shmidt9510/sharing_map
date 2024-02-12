import 'package:secure_shared_preferences/secure_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;
  static late SecureSharedPref _secureSharedPref;
  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _secureSharedPref = await SecureSharedPref.getInstance();
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
      await _secureSharedPref.getString(keyAuthToken, isEncrypted: true) ?? "";

  set authToken(String value) {
    _secureSharedPref.putString(keyAuthToken, value, isEncrypted: true);
  }

  Future<String> getRefreshToken() async =>
      await _secureSharedPref.getString(keyRefreshToken, isEncrypted: true) ??
      "";

  set refreshToken(String value) {
    _secureSharedPref.putString(keyRefreshToken, value, isEncrypted: true);
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

  String get initPath => _sharedPrefs.getString("init_pathp") ?? "";

  set initPath(String value) {
    _sharedPrefs.setString("init_path", value);
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
