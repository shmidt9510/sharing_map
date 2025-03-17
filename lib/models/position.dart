import 'package:geolocator/geolocator.dart';

class SMPosition {
  final double latitude;
  final double longitude;

  SMPosition(this.latitude, this.longitude);

  factory SMPosition.fromPosition(Position pos) =>
      SMPosition(pos.latitude, pos.longitude);

  factory SMPosition.fromJson(Map<String, dynamic> json) =>
      SMPosition(json["latitude"], json["longitude"]);

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude};
}
