import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/user_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';

class UserController extends GetxController {
  var isLoading = true.obs;
  User? myself = null;
  @override
  void onInit() {
    super.onInit();
    CheckAuthorization();
  }

  Future<void> CheckAuthorization() async {
    if (!SharedPrefs().logged) {
      return;
    }

    if (SharedPrefs().userId.isNotEmpty) {
      myself = await GetUser(SharedPrefs().userId);
    }
  }

  Future<bool> Signup(String email, String username, String password) async {
    try {
      String result = await UserWebService.signup(email, username, password);
      debugPrint("result result");
      if (result.isEmpty) {
        debugPrint("isEmpty");
        return false;
      }
      SharedPrefs().confirmationToken = result;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> SignupConfirm(String token) async {
    if (SharedPrefs().confirmationToken.isEmpty) {
      return false;
    }
    try {
      String result = await UserWebService.signupConfirm(
          SharedPrefs().confirmationToken, token);
      debugPrint("result result");
      if (result.isEmpty) {
        debugPrint("isEmpty");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> Login(String email, String password) async {
    try {
      bool result = await UserWebService.login(email, password);
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> UpdateUser(User user, XFile? xfile) async {
    try {
      bool result = await UserWebService.updateUser(user, xfile);
      if (result && myself != null) {
        myself?.bio = user.bio;
        myself?.username = user.username;
      }
      return result;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("why here");
      return false;
    }
  }

  Future<User> GetUser(String id) async {
    var result = await UserWebService.getUser(id);
    if (id == SharedPrefs().userId) {
      myself = result;
    }
    return result;
  }

  Future<User> GetMyself() async {
    if (myself != null) {
      return myself!;
    }
    if (SharedPrefs().userId.isEmpty) {
      return Future.error("no_data");
    }
    return await UserWebService.getUser(SharedPrefs().userId);
  }

  Future<bool> Logout() async {
    // var result = await UserWebService.getUser(id);
    // if (id == SharedPrefs().userId) {
    //   myself = result;
    // }
    // return result;
    return true;
  }

  Future<bool> DeleteMyself() async {
    return true;
    // return await UserWebService.getUser(SharedPrefs().userId);
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
