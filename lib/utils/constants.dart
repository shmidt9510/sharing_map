import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String BACK_URL = dotenv.get('BACKEND_URL');
}
