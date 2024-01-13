import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/models/contact.dart';
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

  Future<bool> CheckAuthorization() async {
    if (!SharedPrefs().logged) {
      return false;
    }

    if (SharedPrefs().userId.isNotEmpty) {
      // myself = await GetUser(SharedPrefs().userId);
      if (!await UserWebService.isAuth()) {
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> Signup(String email, String username, String password) async {
    try {
      String result = await UserWebService.signup(email, username, password);
      if (result.isEmpty) {
        return false;
      }
      SharedPrefs().confirmationToken = result;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> SignupConfirm(String token) async {
    if (SharedPrefs().confirmationToken.isEmpty) {
      return false;
    }
    try {
      return await UserWebService.signupConfirm(
          SharedPrefs().confirmationToken, token);
    } catch (e) {
      return false;
    }
  }

  Future<bool> Login(String email, String password) async {
    try {
      bool result = await UserWebService.login(email, password);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpdateUser(User user, XFile? xfile) async {
    try {
      bool result = await UserWebService.updateUser(user);
      if (result && myself != null) {
        myself?.bio = user.bio;
        myself?.username = user.username;
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpdateUserPhoto(XFile xfile) async {
    try {
      return await UserWebService.updateUserPhoto(xfile);
    } catch (e) {
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
    await SharedPrefs().clear();
    SharedPrefs().isFirstRun = false;
    // var result = await UserWebService.getUser(id);
    // if (id == SharedPrefs().userId) {
    //   myself = result;
    // }
    // return result;
    return true;
  }

  Future<bool> DeleteMyself() async {
    await SharedPrefs().clear();
    SharedPrefs().isFirstRun = false;
    return true;
    // return await UserWebService.getUser(SharedPrefs().userId);
  }

  // Future<bool> ResetPassword(String email) async {
  //   try {
  //     String result = await UserWebService.resetPassword(email);
  //     if (result.isEmpty) {
  //       return false;
  //     }
  //     SharedPrefs().confirmationToken = result;
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<bool> ResetPasswordConfirm(String token) async {
  //   if (SharedPrefs().confirmationToken.isEmpty) {
  //     return false;
  //   }
  //   try {
  //     return await UserWebService.signupConfirm(
  //         SharedPrefs().confirmationToken, token);
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<List<UserContact>> getUserContact(String userId) async {
    try {
      return UserWebService.getUserContact(userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<UserContact> saveContact(UserContact contact) async {
    try {
      return contact.id == null
          ? UserWebService.saveContact(contact)
          : UserWebService.updateContact(contact);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
