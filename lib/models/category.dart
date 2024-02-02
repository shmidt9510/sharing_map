class ItemCategory {
  final int id;
  final String name;
  final String description;
  final DateTime updatedAt;

  ItemCategory(this.id, this.name, this.description, this.updatedAt);

  factory ItemCategory.fromJson(Map<String, dynamic> json) => ItemCategory(
      json["id"],
      json["name"],
      json["description"],
      json["updatedAt"] == null
          ? DateTime.now()
          : DateTime.parse(json["updatedAt"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "updatedAt": updatedAt
      };
}
