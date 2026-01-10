import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:sharing_map/services/core/http_client.dart';

class CommonService extends BaseService<dynamic> {
  @override
  String get basePath => '';

  @override
  fromJson(Map<String, dynamic> json) => json;

  @override
  Map<String, dynamic> toJson(model) => model as Map<String, dynamic>;

  Future<List<ItemCategory>> fetchCategories() async {
    try {
      final response =
          await getList('/categories/all', fromJson: ItemCategory.fromJson);
      return response..sort(_compareByPosition);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Subcategory>> fetchSubcategories() async {
    try {
      final response =
          await getList('/subcategories/all', fromJson: Subcategory.fromJson);
      return response..sort(_compareById);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<City>> fetchCities() async {
    try {
      final response = await getList('/cities/all', fromJson: City.fromJson);
      return response..sort(_compareById);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SMLocation>> fetchLocations(int cityId) async {
    try {
      final response = await getList('/locations/$cityId/all',
          fromJson: SMLocation.fromJson);
      return response..sort(_compareByName);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final client = AppHttpClient().client;
      final response = await client
          .get(buildUri('/ping'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  int _compareByPosition(dynamic a, dynamic b) {
    final aPos = a.position ?? 999;
    final bPos = b.position ?? 999;
    return aPos.compareTo(bPos);
  }

  int _compareByName(dynamic a, dynamic b) {
    final aName = a.name ?? '';
    final bName = b.name ?? '';
    return aName.compareTo(bName);
  }

  int _compareById(dynamic a, dynamic b) {
    final aId = a.id ?? '';
    final bId = b.id ?? '';
    return aId.compareTo(bId);
  }
}
