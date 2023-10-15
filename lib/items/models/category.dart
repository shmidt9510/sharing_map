
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
      name: json["category_name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": name,
        "description": description,
        "image_url": imageUrl,
        "updated_at": updatedAt
      };
}
