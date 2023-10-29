import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/utils/s3_client.dart';

class CachedImage {
  static CachedNetworkImage Get(SMImage image) {
    return CachedNetworkImage(
        imageUrl: S3Client.GetPresigned(image.BuildPath()).toString(),
        progressIndicatorBuilder: (context, url, progress) =>
            const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ));
  }
}
