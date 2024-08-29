int compareByPosition(ItemCategory left, ItemCategory right) {
  var a = left.position ?? 0;
  var b = right.position ?? 0;
  return a == b ? a.compareTo(b) : left.id.compareTo(right.id);
}

class ItemCategory {
  final int id;
  final String name;
  final String description;
  final DateTime updatedAt;
  final String? pictureUrl;
  final int? position;

  ItemCategory(this.id, this.name, this.description, this.updatedAt,
      {this.pictureUrl = "", this.position = 0});

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
      json["id"],
      json["name"],
      json["description"],
      json["updatedAt"] == null
          ? DateTime.now()
          : DateTime.parse(json["updatedAt"]),
      pictureUrl: json.containsKey("pictureUrl") ? json["pictureUrl"] : "",
      position: json.containsKey("position") ? json["position"] : 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "updatedAt": updatedAt,
        "pictureUrl": pictureUrl,
        "position": position
      };
}
