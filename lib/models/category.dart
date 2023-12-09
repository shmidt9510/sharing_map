class ItemCategory {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final DateTime? updatedAt;

  ItemCategory(
      {this.id, this.name, this.description, this.imageUrl, this.updatedAt});

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      updatedAt:
          json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "updatedAt": updatedAt
      };
}
