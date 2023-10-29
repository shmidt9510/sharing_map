import 'package:flutter/material.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/user_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/services/user_service.dart';

class UserController extends GetxController {
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    CheckAuthorization();
  }

  Future<void> CheckAuthorization() async {
    if (!SharedPrefs().logged) {
      return;
    }
    isLoading(true);
    try {
      isLoading(true);
      await UserWebService.refresh();
    } catch (e) {
      Future.error("no_data");
    } finally {
      isLoading(false);
    }
    return;
  }

  Future<bool> Signup(String email, String username, String password) async {
    try {
      String result = await UserWebService.signup(email, username, password);
      debugPrint("result result");
      if (result.isEmpty) {
        debugPrint("isEmpty");
        return false;
      }
      debugPrint("set result");
      SharedPrefs().userId = result;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("why here");
      return false;
    }
  }

  Future<bool> Login(String email, String password) async {
    try {
      bool result = await UserWebService.login(email, password);
      debugPrint("find_ok");
      return result;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("why here");
      return false;
    }
  }
  // Future
  // Future<RxList<Item>> waitItem() async {
  //   await fetchItems();
  //   return items;
  // }

  // void onRefresh() async {
  //   CheckAuthorization();
  // }

  // // void fetchQuery(String query) async {
  // //   isLoading(true);

  // //   try {
  // //     isLoading(true);
  // //     var articleTemp = await ItemWebService.fetchItemsQuery(query);
  // //     if (articleTemp != null) {
  // //       articles(articleTemp);
  // //     }
  // //   } finally {
  // //     isLoading(false);
  // //   }
  // // }

  // void addItem(Item item) async {
  //   isLoading(true);

  //   try {
  //     isLoading(true);
  //     var response = await ItemWebService.addItem(item);
  //     if (response.isEmpty) {
  //       isLoading(false);
  //     }
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
