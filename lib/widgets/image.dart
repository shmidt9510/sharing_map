import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/utils/s3_client.dart';

class CachedImage {
  static Widget Get(SMImage image, {BoxFit fit = BoxFit.contain}) {
    return FutureBuilder<Uri>(
        future: S3Client.GetPresigned(image.BuildPath()),
        builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
          if (snapshot.hasData) {
            var uri = snapshot.data as Uri;
            return CachedNetworkImage(
                fit: fit,
                imageUrl: uri.toString(),
                progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ));
          } else if (snapshot.hasError) {
            return Placeholder();
          } else {
            return Center(
              child: Row(children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ]),
            );
          }
        });
    // String url = (S3Client.GetPresigned(image.BuildPath())).toString();
    // return CachedNetworkImage(
    //     imageUrl: url,
    //     progressIndicatorBuilder: (context, url, progress) =>
    //         const CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => const Center(
    //           child: Icon(
    //             Icons.error,
    //             color: Colors.red,
    //           ),
    //         ));
  }

  static Widget GetProvider(SMImage image) {
    return FutureBuilder<Uri>(
        future: S3Client.GetPresigned(image.BuildPath()),
        builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
          if (snapshot.hasData) {
            var uri = snapshot.data as Uri;
            return CachedNetworkImage(
                imageUrl: uri.toString(),
                progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ));
          } else if (snapshot.hasError) {
            return Placeholder();
          } else {
            return Center(
              child: Row(children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ]),
            );
          }
        });
  }
}
