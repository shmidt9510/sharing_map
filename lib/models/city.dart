class City {
  final int id;
  final String name;
  final DateTime? updatedAt;

  City(this.id, this.name, this.updatedAt);

  factory City.fromJson(Map<String, dynamic> json) => City(
      json["id"],
      json["name"],
      json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]));

  Map<String, dynamic> toJson() =>
      {"id": id, "category_name": name, "updated_at": updatedAt};
}
