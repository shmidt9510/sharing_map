import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/utils/s3_client.dart';

class CachedImage {
  static Widget Get(SMImage image,
      {BoxFit fit = BoxFit.contain, Widget? noDataWidget = null}) {
    var uri = image.BuildPath();
    if (uri == "ERROR") {
      return Placeholder();
    }
    final String imageUrl = "https://" + S3Client.GetHost() + "/" + uri;
    return CachedNetworkImage(
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

  static Future<bool> EvictUserProfileImage(String id) async {
    final String imageUrl =
        "https://" + S3Client.GetHost() + "/" + id + "/" + id;
    var result = await CachedNetworkImage.evictFromCache(imageUrl,
        cacheKey: imageUrl.hashCode.toUnsigned(20).toRadixString(16));
    return result;
  }
}
