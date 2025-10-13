class AddressResponseDto {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final List<String> locations;
  final String cityId;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressResponseDto({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.locations,
    required this.cityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressResponseDto.fromJson(Map<String, dynamic> json) {
    return AddressResponseDto(
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

class CreateAddressDto {
  final String name;
  final String? description;
  final String cityId;
  final List<String> locationIds;

  CreateAddressDto({
    required this.name,
    this.description,
    required this.cityId,
    required this.locationIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'cityId': cityId,
      'locationIds': locationIds,
    };
  }

  factory CreateAddressDto.fromJson(Map<String, dynamic> json) {
    return CreateAddressDto(
      name: json['name'],
      description: json['description'],
      cityId: json['cityId'],
      locationIds: List<String>.from(json['locationIds']),
    );
  }
}

class UpdateAddressDto {
  final String? name;
  final String? description;
  final String? cityId;
  final List<String>? locationIds;

  UpdateAddressDto({
    this.name,
    this.description,
    this.cityId,
    this.locationIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (cityId != null) data['cityId'] = cityId;
    if (locationIds != null) data['locationIds'] = locationIds;

    return data;
  }

  factory UpdateAddressDto.fromJson(Map<String, dynamic> json) {
    return UpdateAddressDto(
      name: json['name'],
      description: json['description'],
      cityId: json['cityId'],
      locationIds: json['locationIds'] != null
          ? List<String>.from(json['locationIds'])
          : null,
    );
  }
}
