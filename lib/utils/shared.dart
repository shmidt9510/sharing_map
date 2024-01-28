import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get userId => _sharedPrefs.getString(keyUserId) ?? "";

  set userId(String value) {
    _sharedPrefs.setString(keyUserId, value);
  }

  bool get logged => _sharedPrefs.getBool(keyIsLogged) ?? false;

  set logged(bool value) {
    _sharedPrefs.setBool(keyIsLogged, value);
  }

  String get authToken => _sharedPrefs.getString(keyAuthToken) ?? "";

  set authToken(String value) {
    _sharedPrefs.setString(keyAuthToken, value);
  }

  String get refreshToken => _sharedPrefs.getString(keyRefreshToken) ?? "";

  set refreshToken(String value) {
    _sharedPrefs.setString(keyRefreshToken, value);
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
