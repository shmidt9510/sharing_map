import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/models/position.dart';
import 'photo.dart';

class Item {
  final String id;
  final String name;
  final String desc;
  final String userId;
  final List<int>? categoryIds;
  final int? subcategoryId;
  final int cityId;
  final List<int>? locationIds;
  final DateTime? creationDate;
  final DateTime? updateDate;
  final List<SMImage>? images;
  final List<XFile>? downloadableImages;
  final String? adress;
  final SMPosition? position;
  final String? username;
  // final Set<
  // final String? author;

  // Item(this.id, this.name, this.desc, this.picture, this.creationDate);

  Item(this.id, this.name, this.desc, this.cityId, this.userId,
      {this.creationDate,
      this.categoryIds,
      this.subcategoryId,
      this.locationIds,
      this.downloadableImages = null,
      this.adress = null,
      this.images,
      this.updateDate,
      this.position,
      this.username = null});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      json["id"].toString(),
      json["name"],
      json["text"],
      json["cityId"],
      json["userId"],
      creationDate:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updateDate:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      locationIds: List<int>.from(json["locationsId"]),
      categoryIds: List<int>.from(json["categoriesId"]),
      subcategoryId: json["subcategoryId"],
      adress: json["address"],
      position: json["position"]?.let((value) => SMPosition.fromJson(value)),
      images: List<SMImage>.from(json["imagesId"].map((model) =>
          SMImage.fromJson(model.toString(), json["id"].toString()))),
      username: json["username"]);
  // (json["images"].map((x) => SMImage.fromJson(x))).toList<SMImage>());

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "text": desc,
        // "user": {"id": userId},
        "cityId": cityId,
        "categoriesId": categoryIds,
        "subcategoryId": subcategoryId,
        "locationsId": locationIds,
        "images": images?.map((x) => x.toJson()),
        "adress": adress,
        "position": position?.toJson()
      };
}
