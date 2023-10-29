class SMImage {
  final String? id;
  final String? itemId;
  final DateTime? updatedAt;
  // final Url? url;
  SMImage({this.id, this.itemId, this.updatedAt});

  factory SMImage.fromJson(Map<String, dynamic> json, String itemId_) =>
      SMImage(
          id: json["id"],
          itemId: itemId_,
          // picture: json["picture"],
          updatedAt: json["updated_at"] == null
              ? null
              : DateTime.parse(json["updated_at"]));

  Map<String, dynamic> toJson() =>
      {"id": id, "item_id": itemId, "updated_at": updatedAt};

  String BuildPath() {
    if (id == null || itemId == null) {
      return "ERROR";
    }
    return itemId! + "/" + id!;
  }
}
