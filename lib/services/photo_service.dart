import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/services/core/http_client.dart';
import 'package:sharing_map/services/core/models/api_response.dart';
import 'package:sharing_map/utils/s3_client.dart';

class PhotoService extends BaseService<Map<String, dynamic>> {
  final http.Client _client = AppHttpClient().client;

  @override
  String get basePath => '';

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> model) => model;

  /// Fetches presigned URLs for uploading images.
  // Future<List<String>> _getPresignedUrls(String itemId, int count) async {
  //   final urls = await getList<String>(
  //     '/$itemId/image/urls',
  //     queryParams: {'count': count},
  //     fromJson: (_) => throw ApiException(
  //       'unexpected_json_object_in_url_list',
  //       0,
  //     ),
  //   );
  //   // getList expects List<Map>, but presigned URLs come as List<String>.
  //   // We need a raw list parse instead — use the dedicated method below.
  //   throw UnimplementedError('Use _getPresignedUrlsRaw instead');
  // }

  Future<List<String>> _getUserPresignedUrls(int count) async {
    final uri = buildUri('/user/photo/urls', {'count': count});

    final response = await _client.get(uri, headers: _defaultHeaders);

    return handleResponse<List<String>>(
      response,
      (json) {
        if (json is! List) {
          throw ApiException('expected_list_got_${json.runtimeType}', 200);
        }
        return json.cast<String>();
      },
    );
  }

  /// Fetches presigned upload URLs as raw strings from the API.
  Future<List<String>> _getPresignedUrls(String itemId, int count) async {
    final uri = buildUri('/$itemId/image/urls', {'count': count});

    final response = await _client.get(uri, headers: _defaultHeaders);

    return handleResponse<List<String>>(
      response,
      (json) {
        if (json is! List) {
          throw ApiException('expected_list_got_${json.runtimeType}', 200);
        }
        return json.cast<String>();
      },
    );
  }

  Future<bool> addUserPhotos(List<XFile> files) async {
    if (files.isEmpty) return true;

    final urls = await _getUserPresignedUrls(files.length);

    if (urls.length != files.length) {
      throw ApiException(
        'url_count_mismatch',
        0,
        'Expected ${files.length} URLs, got ${urls.length}',
      );
    }

    await _uploadFilesToS3(files, urls);

    return true;
  }

  /// Uploads photos to S3 using presigned URLs obtained from the backend.
  Future<bool> addPhotos(List<XFile> files, String itemId) async {
    if (files.isEmpty) return true;

    final urls = await _getPresignedUrls(itemId, files.length);

    if (urls.length != files.length) {
      throw ApiException(
        'url_count_mismatch',
        0,
        'Expected ${files.length} URLs, got ${urls.length}',
      );
    }

    await _uploadFilesToS3(files, urls);

    return true;
  }

  /// Uploads each file to its corresponding presigned S3 URL.
  Future<void> _uploadFilesToS3(List<XFile> files, List<String> urls) async {
    for (int i = 0; i < files.length; i++) {
      final uploadSuccess = await S3Client.UploadFile(
        Uri.parse(urls[i]),
        files[i],
      );

      if (!uploadSuccess) {
        throw ApiException(
          'file_upload_failed',
          0,
          'Failed to upload file: ${files[i].name}',
        );
      }
    }
  }

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
