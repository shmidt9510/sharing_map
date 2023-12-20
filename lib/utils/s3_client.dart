import 'dart:developer';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class S3Client {
  static Future<Uri> GetPresigned(String path) async {
    final host = GetHost_();
    // Create a pre-signed URL for downloading the file
    final urlRequest = AWSHttpRequest.get(
      Uri.https(host, path),
      headers: {
        AWSHeaders.host: host,
      },
    );
    final signedUrl = await GetSigner_().presignSync(
      urlRequest,
      credentialScope: GetScope_(),
      serviceConfiguration: S3ServiceConfiguration(),
      expiresIn: const Duration(minutes: 10),
    );
    log(signedUrl.toString());
    return signedUrl;
  }

  static AWSSigV4Signer GetSigner_() {
    return AWSSigV4Signer(
        credentialsProvider: AWSCredentialsProvider.dartEnvironment());
  }

  static String GetHost_() {
    return dotenv.get('S3_BUCKET') + "." + dotenv.get('S3_STORAGE_URL');
  }

  static AWSCredentialScope GetScope_() {
    String region = dotenv.get('S3_REGION');
    return AWSCredentialScope(
      region: region,
      service: AWSService.s3,
    );
  }

  static Future UploadFile(Uri url, XFile image) async {
    var response = await put(url,
        body: await image.readAsBytes(),
        headers: {"Content-Type": "image/jpg"});
    if (response.statusCode / 200 != 1) {
      return Future.error(response.toString());
    }
  }
}
