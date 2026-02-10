import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String BACK_URL = dotenv.get('BACKEND_URL');
  static String BACKEND_SCHEME =
      dotenv.get('BACKEND_SCHEME', fallback: 'https');

  static Uri buildUri(String path) {
    if (BACKEND_SCHEME == 'http') {
      return Uri.http(BACK_URL, path);
    }
    return Uri.https(BACK_URL, path);
  }
}
