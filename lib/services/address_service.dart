import 'package:sharing_map/services/core/base_service.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/services/address_dto.dart';

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

  Future<Address> addAddress(CreateAddressDto createAddressDto) async {
    return post('$basePath/add', createAddressDto as Address);
  }

  Future<AddressResponseDto> updateAddress(
    String addressId,
    UpdateAddressDto updateAddressDto,
  ) async {
    final response = await put(
      '$basePath/update/$addressId',
      updateAddressDto as Address,
    );
    return AddressResponseDto.fromJson(toJson(response));
  }

  Future<void> deleteAddress(String addressId) async {
    return delete('$basePath/delete/$addressId');
  }
}
