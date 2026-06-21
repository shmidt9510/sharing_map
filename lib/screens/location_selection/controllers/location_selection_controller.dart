import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/services/address_service.dart';

/// Owns all location/address state and business logic so the widgets
/// stay purely declarative. No `build()`-time computation, no widget
/// field mutation.
class LocationSelectionController extends GetxController {
  LocationSelectionController({
    required this.subcategoryId,
    required List<SMLocation> initialLocations,
    required List<Address> initialAddresses,
  })  : chosenLocations = initialLocations.obs,
        addresses = initialAddresses.obs;

  final int subcategoryId;
  final RxList<SMLocation> chosenLocations;
  final RxList<Address> addresses;
  final Rxn<Address> selectedAddress = Rxn<Address>();

  final _addressService = AddressService();
  CommonController get _common => Get.find<CommonController>();

  /// Converts an address's stored location-id strings into [SMLocation]s.
  /// Uses tryParse so a bad id is skipped, not thrown.
  List<SMLocation> locationsOf(Address address) => address.locations
      .map(int.tryParse)
      .where((id) => id != null)
      .map((id) => _common.locationsMap[id])
      .whereType<SMLocation>()
      .toList();

  bool isSelected(Address address) => selectedAddress.value?.id == address.id;

  void toggleAddress(Address address) {
    if (isSelected(address)) {
      selectedAddress.value = null;
      chosenLocations.clear();
    } else {
      selectedAddress.value = address;
      chosenLocations.assignAll(locationsOf(address));
    }
  }

  void setLocations(List<SMLocation> locations) {
    selectedAddress.value = null;
    chosenLocations.assignAll(locations);
  }

  void onAddressCreated(Address address) {
    addresses.add(address);
    selectedAddress.value = address;
    chosenLocations.assignAll(locationsOf(address));
  }

  Future<bool> deleteAddress(Address address) async {
    await _addressService.deleteAddress(address.id);
    addresses.remove(address);
    if (selectedAddress.value?.id == address.id) {
      selectedAddress.value = null;
      chosenLocations.clear();
    }
    return true;
  }

  String? validate() {
    if (chosenLocations.isEmpty) return 'Пожалуйста, выберите локации';
    if (chosenLocations.length > 3) return 'Не больше трёх локаций';
    return null;
  }

  void replaceAddress(Address updated) {
    final index = addresses.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      addresses[index] = updated;
    } else {
      addresses.add(updated);
    }
    addresses.refresh(); // RxList doesn't notify on index assignment

    if (selectedAddress.value?.id == updated.id) {
      selectedAddress.value = updated;
      chosenLocations.assignAll(locationsOf(updated));
    }
  }

  Future<bool> updateAddress(Address edited) async {
    final response = await _addressService.updateAddress(edited.id, edited);

    final refreshed = Address(
      id: response.id,
      name: response.name,
      description: response.description,
      userId: response.userId,
      locations: response.locations,
      cityId: response.cityId,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );

    final index = addresses.indexWhere((a) => a.id == refreshed.id);
    if (index != -1) {
      addresses[index] = refreshed;
    } else {
      addresses.add(refreshed);
    }
    addresses.refresh();

    if (selectedAddress.value?.id == refreshed.id) {
      selectedAddress.value = refreshed;
      chosenLocations.assignAll(locationsOf(refreshed));
    }

    return true;
  }
}
