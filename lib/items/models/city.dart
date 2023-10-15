class City {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? updatedAt;

  City({this.id, this.name, this.description, this.updatedAt});

  factory City.fromJson(Map<String, dynamic> json) => City(
      id: json["id"],
      name: json["category_name"],
      description: json["description"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": name,
        "description": description,
        "updated_at": updatedAt
      };
}
