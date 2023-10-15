import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:sharing_map/utils/constants.dart';
import 'interceptors.dart';

// import 'package:sharing_map/items/models/photo.dart';
// import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sharing_map/utils/s3_client.dart';

class PhotoWebService {
  static var client = InterceptedClient.build(
    interceptors: [
      LoggerInterceptor(),
    ],
  );

  Future<bool> addPhotos(List<XFile> files, String itemId) async {
    var uri = "/" + itemId + "/image/urls";

    var response =
        await client.get(Uri.parse(Constants.BACK_URL + uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });

    if (response.statusCode != HttpStatus.ok) {
      Future.error("error code " + response.statusCode.toString());
      return false;
    }
    final List<dynamic> data = json.decode(response.body);

    bool isUploaded =
        await S3Client.UploadFile(Uri.parse(data[0].toString()), files[0]);
    if (!isUploaded) {
      return false;
    }
    return true;
  }
}
