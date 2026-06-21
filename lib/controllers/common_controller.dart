import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/services/core/models/api_response.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/models/subcategory.dart';
import 'package:sharing_map/services/common_service.dart';

/// Controller for common app data (categories, cities, locations)
class CommonController extends GetxController {
  final CommonService _commonService = CommonService();

  // Observable lists
  final categories = <ItemCategory>[].obs;
  final subcategories = <Subcategory>[].obs;
  final cities = <City>[].obs;
  final locations = <SMLocation>[].obs;

  // Location map for quick lookup
  final locationsMap = <int, SMLocation>{}.obs;

  // Loading states
  final isLoadingCommonData = false.obs;
  final isLoadingLocations = false.obs;

  // Error states
  final Rx<String?> commonDataError = Rx<String?>(null);
  final Rx<String?> locationsError = Rx<String?>(null);

  // Current city ID (for tracking location changes)
  final currentCityId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    // Fetch common data on initialization
    fetchCommonData();
  }

  /// Fetch categories, subcategories, and cities
  Future<void> fetchCommonData({bool forceRefresh = false}) async {
    // Skip if already loaded and not forcing refresh
    if (!forceRefresh && _isCommonDataLoaded) {
      debugPrint('✅ Common data already loaded, skipping fetch');
      return;
    }

    isLoadingCommonData.value = true;
    commonDataError.value = null;

    try {
      debugPrint('📥 Fetching common data...');

      // Fetch all data in parallel
      final results = await Future.wait([
        _commonService.fetchCategories(),
        _commonService.fetchSubcategories(),
        _commonService.fetchCities(),
      ]);

      // Update categories
      if (results[0] is List<ItemCategory>) {
        categories.value = results[0] as List<ItemCategory>;
        debugPrint('✅ Loaded ${categories.length} categories');
      }

      // Update subcategories
      if (results[1] is List<Subcategory>) {
        subcategories.value = results[1] as List<Subcategory>;
        debugPrint('✅ Loaded ${subcategories.length} subcategories');
      }

      // Update cities
      if (results[2] is List<City>) {
        cities.value = results[2] as List<City>;
        debugPrint('✅ Loaded ${cities.length} cities');
      }

      debugPrint('✅ Common data fetch completed successfully');
    } on ApiException catch (e) {
      commonDataError.value = e.code;
      debugPrint('❌ API error fetching common data: ${e.code}');
      _handleCommonDataError(e);
    } catch (e) {
      commonDataError.value = 'unexpected_error';
      debugPrint('❌ Unexpected error fetching common data: $e');
      _showErrorSnackbar('Failed to load app data', '$e');
    } finally {
      isLoadingCommonData.value = false;
    }
  }

  /// Fetch locations for a specific city
  Future<void> fetchLocations(int cityId, {bool forceRefresh = false}) async {
    // Skip if same city and already loaded
    if (!forceRefresh &&
        currentCityId.value == cityId &&
        locations.isNotEmpty) {
      debugPrint('✅ Locations for city $cityId already loaded');
      return;
    }

    isLoadingLocations.value = true;
    locationsError.value = null;

    try {
      debugPrint('📥 Fetching locations for city $cityId...');

      final fetchedLocations = await _commonService.fetchLocations(cityId);

      // Update locations and map
      locations.value = fetchedLocations;
      locationsMap.clear();

      for (final location in fetchedLocations) {
        locationsMap[location.id] = location;
      }

      currentCityId.value = cityId;
      debugPrint('✅ Loaded ${locations.length} locations for city $cityId');
    } on ApiException catch (e) {
      locationsError.value = e.code;
      debugPrint('❌ API error fetching locations: ${e.code}');
      _handleLocationsError(e);
    } catch (e) {
      locationsError.value = 'unexpected_error';
      debugPrint('❌ Unexpected error fetching locations: $e');
      _showErrorSnackbar('Failed to load locations', '$e');
    } finally {
      isLoadingLocations.value = false;
    }
  }

  /// Check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    try {
      return await _commonService.checkInternetConnectivity();
    } catch (e) {
      debugPrint('❌ Internet connectivity check failed: $e');
      return false;
    }
  }

  /// Get location by ID
  SMLocation? getLocationById(int locationId) {
    return locationsMap[locationId];
  }

  /// Get category by ID
  ItemCategory? getCategoryById(int categoryId) {
    try {
      return categories.firstWhere((cat) => cat.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get subcategory by ID
  Subcategory? getSubcategoryById(int subcategoryId) {
    try {
      return subcategories.firstWhere((sub) => sub.id == subcategoryId);
    } catch (e) {
      return null;
    }
  }

  /// Get city by ID
  City? getCityById(int cityId) {
    try {
      return cities.firstWhere((city) => city.id == cityId);
    } catch (e) {
      return null;
    }
  }

  /// Get category image asset
  AssetImage getCategoryImage(ItemCategory category) {
    final assetName = _categoryAssetsMap[category.name] ?? 'other';
    return AssetImage('assets/images/categories/$assetName.png');
  }

  /// Get category image by name
  AssetImage getCategoryImageByName(String categoryName) {
    final assetName = _categoryAssetsMap[categoryName] ?? 'other';
    return AssetImage('assets/images/categories/$assetName.png');
  }

  /// Check if category image exists
  bool hasCategoryImage(String categoryName) {
    return _categoryAssetsMap.containsKey(categoryName);
  }

  /// Clear all data (useful for logout)
  void clearData() {
    categories.clear();
    subcategories.clear();
    cities.clear();
    locations.clear();
    locationsMap.clear();
    currentCityId.value = null;
    commonDataError.value = null;
    locationsError.value = null;
    debugPrint('🗑️ Common data cleared');
  }

  /// Retry loading common data
  Future<void> retryCommonData() async {
    return fetchCommonData(forceRefresh: true);
  }

  /// Retry loading locations
  Future<void> retryLocations() async {
    if (currentCityId.value != null) {
      return fetchLocations(currentCityId.value!, forceRefresh: true);
    }
  }

  // Private helpers

  bool get _isCommonDataLoaded {
    return categories.isNotEmpty &&
        subcategories.isNotEmpty &&
        cities.isNotEmpty;
  }

  void _handleCommonDataError(ApiException e) {
    switch (e.code) {
      case 'network_error':
        _showErrorSnackbar(
          'Network Error',
          'Please check your internet connection',
        );
        break;
      case 'unauthorized':
        _showErrorSnackbar(
          'Authentication Error',
          'Please log in again',
        );
        break;
      default:
        _showErrorSnackbar(
          'Error',
          'Failed to load app data: ${e.code}',
        );
    }
  }

  void _handleLocationsError(ApiException e) {
    switch (e.code) {
      case 'network_error':
        _showErrorSnackbar(
          'Network Error',
          'Please check your internet connection',
        );
        break;
      case 'not_found':
        _showErrorSnackbar(
          'No Locations',
          'No locations found for this city',
        );
        break;
      default:
        _showErrorSnackbar(
          'Error',
          'Failed to load locations: ${e.code}',
        );
    }
  }

  void _showErrorSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        icon: const Icon(Icons.error_outline, color: Colors.red),
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Category asset mapping
  static const Map<String, String> _categoryAssetsMap = {
    'all': 'all',
    'appliance': 'appliance',
    'auto': 'auto',
    'beauty_bath': 'beauty_bath',
    'beauty_cosmetics': 'beauty_cosmetics',
    'books': 'books',
    'child': 'child',
    'clothes': 'clothes',
    'dacha': 'dacha',
    'favorite': 'favorite',
    'food': 'food',
    'hand': 'hand',
    'health': 'health',
    'hobby': 'hobby',
    'home': 'home',
    'other': 'other',
    'pets': 'pets',
    'plants': 'plants',
    'renovation': 'renovation',
    'sport': 'sport',
    'tourism': 'tourism',
  };

  /// Get all available category asset names
  static List<String> get availableCategoryAssets =>
      _categoryAssetsMap.values.toList();

  @override
  void onClose() {
    debugPrint('🔴 CommonController disposed');
    super.onClose();
  }
}
