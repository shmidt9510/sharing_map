import 'package:flutter/material.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/widgets/image.dart';

const String PlaceholderId = "8d762611-38ff-41ff-ba2d-7dbfab85d750";

class User {
  final String id;
  String username;
  bool? hasProfileImage = false;
  String? email;
  String bio;

  User({
    required this.id,
    required this.username,
    this.hasProfileImage,
    this.email,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      hasProfileImage: json["hasImage"],
      // profileImage: json["imagePath"],
      bio: json["bio"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "bio": bio, "email": email};

  Widget buildImage({BoxFit fit = BoxFit.contain}) {
    if (hasProfileImage != null && hasProfileImage!) {
      return CachedImage.Get(
          SMImage(id: id, itemId: id, updatedAt: DateTime.now()),
          fit: fit);
    }
    return Image.asset('assets/images/categories/pets.png');
  }

  SMImage getSMImage() {
    if (hasProfileImage != null && !(hasProfileImage!)) {
      return SMImage(
          id: PlaceholderId, itemId: PlaceholderId, updatedAt: DateTime.now());
    }

    return SMImage(id: id, itemId: id, updatedAt: DateTime.now());
  }

    factory User.getEmptyUser() => User(
      id: "",
      username: "",
      bio: "");

}
