import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/services/address_dto.dart';
import 'package:sharing_map/services/common_service.dart';
import 'package:sharing_map/services/interceptors.dart';
import 'package:sharing_map/utils/constants.dart';

class AddressService {
  static var client = InterceptedClient.build(
    requestTimeout: Duration(seconds: 2),
    retryPolicy: CommonServiceRetryPolicy(),
    interceptors: [
      RefreshTokenInterceptor(),
      AuthorizationInterceptor(),
      LoggerInterceptor(),
    ],
  );
  static Future<List<Address>> getAllAddresses() async {
    String uri = "/address/all";

    try {
      var response = await client.get(Uri.https(Constants.BACK_URL, uri));

      if (response.statusCode == 401) {
        return Future.error("unauthorized");
      }
      if (response.statusCode == 404) {
        return Future.error("user_not_found");
      }
      if (response.statusCode != 200) {
        return Future.error("failed_get_addresses");
      }

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      print(jsonData);
      return jsonData.map((address) => Address.fromJson(address)).toList();
    } catch (e) {
      if (e is SocketException) {
        return Future.error("network_error");
      }
      return Future.error("failed_parse_addresses");
    }
  }

  static Future<Address> addAddress(CreateAddressDto createAddressDto) async {
    String uri = "/address/add";

    try {
      var response = await client.post(
        Uri.https(Constants.BACK_URL, uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(createAddressDto.toJson()),
      );

      if (response.statusCode == 401) {
        return Future.error("unauthorized");
      }
      if (response.statusCode == 400) {
        return Future.error("invalid_address_data");
      }
      if (response.statusCode == 404) {
        return Future.error("user_not_found");
      }
      if (response.statusCode != 200) {
        return Future.error("failed_create_address");
      }

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return Address.fromJson(jsonData);
    } catch (e) {
      if (e is SocketException) {
        return Future.error("network_error");
      }
      return Future.error("failed_parse_address");
    }
  }

  static Future<void> deleteAddress(String addressId) async {
    String uri = "/address/delete/$addressId";

    try {
      var response = await client.delete(Uri.https(Constants.BACK_URL, uri));

      if (response.statusCode == 401) {
        return Future.error("unauthorized");
      }
      if (response.statusCode == 403) {
        return Future.error("forbidden_not_owner");
      }
      if (response.statusCode == 404) {
        return Future.error("address_not_found");
      }
      if (response.statusCode != 204) {
        return Future.error("failed_delete_address");
      }

      // Success - no content to return
    } catch (e) {
      if (e is SocketException) {
        return Future.error("network_error");
      }
      return Future.error("failed_delete_address");
    }
  }

  static Future<AddressResponseDto> updateAddress(
      String addressId, UpdateAddressDto updateAddressDto) async {
    String uri = "/address/update/$addressId";

    try {
      var response = await client.put(
        Uri.https(Constants.BACK_URL, uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateAddressDto.toJson()),
      );

      if (response.statusCode == 401) {
        return Future.error("unauthorized");
      }
      if (response.statusCode == 403) {
        return Future.error("forbidden_not_owner");
      }
      if (response.statusCode == 404) {
        return Future.error("address_not_found");
      }
      if (response.statusCode == 400) {
        return Future.error("invalid_address_data");
      }
      if (response.statusCode != 200) {
        return Future.error("failed_update_address");
      }

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return AddressResponseDto.fromJson(jsonData);
    } catch (e) {
      if (e is SocketException) {
        return Future.error("network_error");
      }
      return Future.error("failed_parse_address");
    }
  }
}
