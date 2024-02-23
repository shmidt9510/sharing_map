import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile> compressImage(XFile imageFile, int targetSizeInBytes) async {
  int count = 0;
  if (imageFile.path == null) {
    return Future.error("no_file");
  }
  var imgFile = File(imageFile.path);
  while (await imgFile.lengthSync() > targetSizeInBytes && count < 5) {
    count++;
    var something = await FlutterImageCompress.compressAndGetFile(
      imgFile.absolute.path,
      imgFile.absolute.path + "_compress_{$count}.jpg",
      quality: 50,
    );
    if (something == null) {
      return XFile(imgFile.path);
    }
    imgFile = something as File;
  }
  return XFile(imgFile.path);
}
