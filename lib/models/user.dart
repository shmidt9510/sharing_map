import 'package:flutter/material.dart';
import 'package:sharing_map/models/photo.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/image.dart';

const String PlaceholderId = "8d762611-38ff-41ff-ba2d-7dbfab85d750";

class User {
  final String id;
  String username;
  String? email;
  String? bio;
  SMImage? profileImage = null;

  User(
      {required this.id,
      required this.username,
      this.email,
      this.bio,
      this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      // email: json["email"],
      bio: json["bio"],
      profileImage: json["photo"] != null
          ? SMImage.fromJson(json["photo"])
          : SMImage.Placeholder(),
    );
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "bio": bio, "email": email};

  Widget buildImage({BoxFit fit = BoxFit.contain}) {
    if (profileImage != null) {
      return CachedImage.Get(profileImage!, fit: fit);
    }
    return Padding(
      padding: EdgeInsets.all(0),
      child: Icon(
        Icons.person_rounded,
        color: MColors.darkGreen,
      ),
    );
    // Image.asset('assets/images/categories/pets.png');
  }

  SMImage getSMImage() {
    if (profileImage != null) {
      return profileImage!;
    }
    return SMImage(id: id, itemId: id);
  }

  factory User.getEmptyUser() => User(id: "", username: "", bio: "");
}
