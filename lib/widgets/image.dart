import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/utils/s3_client.dart';

class CachedImage {
  static Widget Get(SMImage image, {BoxFit fit = BoxFit.contain}) {
    var uri = image.BuildPath();
    if (uri == "ERROR") {
      return Placeholder();
    }
    final String imageUrl = "https://" + S3Client.GetHost() + "/" + uri;
    return CachedNetworkImage(
        cacheManager: CacheManager(
          Config(
            'images',
            stalePeriod: Duration(days: 3),
          ),
        ),
        cacheKey: imageUrl.hashCode.toUnsigned(20).toRadixString(16),
        fit: fit,
        imageUrl: imageUrl,
        // progressIndicatorBuilder: (context, url, progress) => const Center(
        //       child: Padding(
        //         padding: const EdgeInsets.all(12.0),
        //         child: Row(children: [
        //           CircularProgressIndicator.adaptive(),
        //         ]),
        //       ),
        //     ),
        errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ));
  }

  static Future<XFile> GetXFile(SMImage image) async {
    var uri = image.BuildPath();
    if (uri == "ERROR") {
      return Future.error("cant_build_path");
    }
    final String imageUrl = "https://" + S3Client.GetHost() + "/" + uri;
    var cacheManager = DefaultCacheManager();

    File cachedFile = await cacheManager.getSingleFile(imageUrl);
    return XFile(cachedFile.path);
  }

  static Future<bool> EvictUserProfileImage(String id) async {
    final String imageUrl =
        "https://" + S3Client.GetHost() + "/" + id + "/" + id;
    var result = await CachedNetworkImage.evictFromCache(imageUrl,
        cacheKey: imageUrl.hashCode.toUnsigned(20).toRadixString(16));
    return result;
  }
}
