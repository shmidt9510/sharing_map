class User {
  final String id;
  final String username;
  final String? imagePath;
  final String email;
  final String bio;

  const User({
    required this.id,
    required this.username,
    this.imagePath,
    required this.email,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      imagePath: json["imagePath"],
      bio: json["bio"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "username": username, "bio": bio, "email": email};
}
