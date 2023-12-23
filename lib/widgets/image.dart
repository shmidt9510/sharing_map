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
        fit: fit,
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, progress) => const Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  CircularProgressIndicator(),
                ]),
              ),
            ),
        errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ));
  }
}
