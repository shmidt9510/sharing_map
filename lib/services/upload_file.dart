import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class UploadFile {
  bool? success;
  String? message;

  bool? isUploaded;

  Future<void> call(Uri uri, XFile image) async {
    try {
      File file = File(image.path);

      Dio dio = new Dio();
      await dio.put(
        uri.toString(),
        data: file.openRead(),
        options: Options(
          contentType: "image/jpg",
          headers: {
            "Content-Length": file.lengthSync(),
          },
        ),
        onSendProgress: (int sentBytes, int totalBytes) {
          double progressPercent = sentBytes / totalBytes * 100;
          print("$progressPercent %");
        },
      );
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}
