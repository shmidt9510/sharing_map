class Address {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final List<String> locations;
  final String cityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.locations,
    required this.cityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['user_id'],
      locations: (json['locationIds'] as List<dynamic>)
          .map((location) => location.toString())
          .toList(),
      cityId: json['cityId'].toString(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'locationIds': locations,
      'cityId': cityId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
