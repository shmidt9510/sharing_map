import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/models/address.dart';

class AddressService extends BaseService<Address> {
  @override
  String get basePath => '/address';

  @override
  Address fromJson(Map<String, dynamic> json) => Address.fromJson(json);

  @override
  Map<String, dynamic> toJson(Address model) => model.toJson();

  Future<List<Address>> getAllAddresses() async {
    return getList('$basePath/all', fromJson: Address.fromJson);
  }

  Future<Address> addAddress(Address address) async {
    return post('$basePath/add', address);
  }

  Future<Address> updateAddress(String addressId, Address address) async {
    return put('$basePath/update/$addressId', address);
  }

  Future<void> deleteAddress(String addressId) async {
    return delete('$basePath/delete/$addressId');
  }
}
