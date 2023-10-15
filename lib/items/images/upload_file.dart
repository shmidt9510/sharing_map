
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadFile {
  bool? success;
  String? message;

  bool? isUploaded;

  Future<void> call(Uri uri, XFile image) async {
    try {
      var response = await http.put(uri, body: image.readAsString());
      if (response.statusCode == 200) {
        isUploaded = true;
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}
