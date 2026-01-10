import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/services/core/models/api_response.dart';
import 'package:sharing_map/utils/constants.dart';
import 'package:sharing_map/utils/s3_client.dart';

class PhotoService {
  final http.Client _client = AppHttpClient().client;

  /// Add photos for an item
  Future<bool> addPhotos(List<XFile> files, String itemId) async {
    if (files.isEmpty) return true;

    try {
      // Get presigned URLs
      final uri = Uri.https(Constants.BACK_URL, '/$itemId/image/urls', {
        'count': files.length.toString(),
      });

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'failed_get_upload_urls',
          response.statusCode,
        );
      }

      final List<dynamic> urls = jsonDecode(response.body);

      if (urls.length != files.length) {
        throw ApiException(
          'url_count_mismatch',
          0,
          'Expected ${files.length} URLs, got ${urls.length}',
        );
      }

      // Upload files to S3
      for (int i = 0; i < files.length; i++) {
        final uploadSuccess = await S3Client.UploadFile(
          Uri.parse(urls[i] as String),
          files[i],
        );

        if (!uploadSuccess) {
          throw Exception('Failed to upload file ${files[i].name}');
        }
      }

      return true;
    } on SocketException {
      throw ApiException('network_error', 0);
    } catch (e) {
      print('Photo upload error: $e');
      rethrow;
    }
  }
}
