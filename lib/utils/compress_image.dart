import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile> compressImage(XFile imageFile, int targetSizeInBytes) async {
  int count = 0;
  var imgFile = imageFile;
  while (await imgFile.length() > targetSizeInBytes && count < 5) {
    count++;
    var something = await FlutterImageCompress.compressAndGetFile(
      imgFile.path,
      imgFile.path + "_compress_{$count}.jpg",
      quality: 50,
    );
    if (something == null) {
      return XFile(imgFile.path);
    }
    imgFile = something;
  }
  return XFile(imgFile.path);
}
