import 'package:sharing_map/models/position.dart';

class City {
  final int id;
  final String name;
  final DateTime? updatedAt;
  final SMPosition? position;
  City(this.id, this.name, this.updatedAt, {this.position});

  factory City.fromJson(Map<String, dynamic> json) => City(
      json["id"],
      json["name"],
      json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      position: json["position"]?.let((value) => SMPosition.fromJson(value)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": name,
        "updated_at": updatedAt,
        "position": position?.toJson()
      };
}
