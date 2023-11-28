import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
      AuthorizationInterceptor(),
    ],
  );

  Future addPhotos(List<XFile> files, String itemId) async {
    var uri = "/" + itemId + "/image/urls";
    var imageCount = files.length;
    var response =
        await client.get(Uri.parse(Constants.BACK_URL + uri), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    }, params: {
      "count": "$imageCount"
    });

    if (response.statusCode != HttpStatus.ok) {
      return Future.error("error code " + response.statusCode.toString());
    }
    final List<dynamic> data = json.decode(response.body);
    if (data.length != files.length) {
      return Future.error("length of urls and photos are not equal");
    }
    for (int i = 0; i < files.length; i++) {
      await S3Client.UploadFile(Uri.parse(data[i].toString()), files[i])
          .onError((error, stackTrace) {
        return false;
      });
    }
    return true;
  }
}
