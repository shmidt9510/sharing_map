import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SMLocation {
  final int id;
  final int cityId;
  final String locationType;
  final String name;
  SMLocation(
      {required this.id,
      required this.cityId,
      required this.name,
      this.locationType = "METRO"});

  factory SMLocation.fromJson(Map<String, dynamic> json) => SMLocation(
      id: json["id"],
      name: json["name"],
      cityId: json["cityId"],
      locationType: json["type"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": locationType,
        "cityId": cityId,
      };

  static List<SMLocation> fromJsonList(List list) {
    return list.map((item) => SMLocation.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String locationAsString() {
    return '#${this.id} ${this.name}';
  }

  // ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt.toString().contains(filter);
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(SMLocation model) {
    return this.name == model.name;
  }

  @override
  String toString() => this.name ?? "";
}

extension LocationIconString on SMLocation {
  Widget get getLocationIcon {
    switch (this.locationType.toLowerCase()) {
      case "metro":
        return SvgPicture.asset(
          'assets/icons/subway_moscow.svg',
          height: 18,
          width: 18,
        );
      case "metro_spb":
        return SvgPicture.asset(
          'assets/icons/spb_metro_logo.svg',
          height: 18,
          width: 18,
        );
      case "railway":
        return Icon(
          Icons.subway,
          size: 18,
        );
      case "neighbourhood":
        return Icon(Icons.location_city_rounded, size: 18);
      case "bus_station":
        return Icon(Icons.directions_bus_filled, size: 18);
      case "village":
        return Icon(Icons.holiday_village_outlined, size: 18);
      default:
        return SvgPicture.asset(
          'assets/icons/subway_moscow.svg',
          height: 18,
          width: 18,
        );
    }
  }
}
