import 'package:sharing_map/models/photo.dart';

class User {
  final String id;
  String username;
  SMImage? profileImage;
  String? email;
  String bio;

  User({
    required this.id,
    required this.username,
    this.profileImage,
    this.email,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      // profileImage: json["imagePath"],
      bio: json["bio"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "bio": bio, "email": email};

  SMImage buildImage() {
    return SMImage(id: id, itemId: id, updatedAt: DateTime.now());
  }
  // profileImage.toJson()
}
