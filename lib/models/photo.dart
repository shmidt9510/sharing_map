enum ImageResolution { SMALL, LOW, NORMAL, HIGH }

extension ImageResolutionExtension on ImageResolution {
  static ImageResolution? fromString(String? resolution) {
    switch (resolution?.toUpperCase()) {
      case 'SMALL':
        return ImageResolution.SMALL;
      case 'LOW':
        return ImageResolution.LOW;
      case 'NORMAL':
        return ImageResolution.NORMAL;
      case 'HIGH':
        return ImageResolution.HIGH;
      default:
        return null;
    }
  }
}

class SMImage {
  final String? id;
  final String? itemId;
  final ImageResolution? resolution;
  final Uri? url;

  SMImage({
    this.id,
    this.itemId,
    this.resolution,
    this.url,
  });

  factory SMImage.fromString(String imageId) => SMImage(id: imageId);

  factory SMImage.fromJson(Map<String, dynamic> json) {
    return SMImage(
      id: json["imageId"],
      itemId: json["objectId"],
      // resolution: ImageResolutionExtension.fromString(json['resolution']),
      url: json["url"] != null ? Uri.tryParse(json["url"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "item_id": itemId};

  String BuildPath() {
    if (id == null || itemId == null) {
      return "ERROR";
    }
    return itemId! + "/" + id!;
  }

  static Placeholder() {}
}
