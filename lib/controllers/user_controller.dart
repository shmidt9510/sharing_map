import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/services/user_service.dart';
import 'package:get/get.dart';
import 'package:sharing_map/utils/shared.dart';

enum SignupResult { ok, noEmail, emailTaken, Failed }

extension SignupExtension on SignupResult {
  String get statusMessage {
    switch (this) {
      case SignupResult.ok:
        return "ok";
      case SignupResult.Failed:
        return "Что-то пошло не так";
      case SignupResult.emailTaken:
        return "Пользователь с таким email уже существует. Попробуйте сбросить пароль";
      case SignupResult.noEmail:
        return "Неверный формат почты";
      default:
        return "";
    }
  }
}

class UserController extends GetxController {
  var myself = Rx<User>(User.getEmptyUser());

  var userProfilePicture =
      Rx<Widget>(User.getEmptyUser().buildImage(fit: BoxFit.cover));

  var myContacts = <UserContact>[].obs;
  var token = ''.obs;

  void setToken(String _token) {
    token.value = _token;
  }

  String getToken() {
    return token.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> CheckAuthorization() async {
    if (SharedPrefs().userId.isEmpty) {
      return false;
    }
    if (!(await UserWebService.isAuth())) {
      return false;
    }
    SharedPrefs().isFirstRun = false;
    SharedPrefs().logged = true;
    return true;
  }

  Future<SignupResult> Signup(
      String email, String username, String password) async {
    try {
      String result = await UserWebService.signup(email, username, password);
      if (result.isEmpty) {
        return SignupResult.Failed;
      }
      if (result == "email_taken") {
        return SignupResult.emailTaken;
      }

      if (result == "invalid_email") {
        return SignupResult.noEmail;
      }
      SharedPrefs().confirmationToken = result;
      return SignupResult.ok;
    } catch (e) {
      return SignupResult.Failed;
    }
  }

  Future<bool> SignupConfirm(String token) async {
    if (SharedPrefs().confirmationToken.isEmpty) {
      return false;
    }
    try {
      var result = await UserWebService.signupConfirm(
          SharedPrefs().confirmationToken, token);
      if (result) {
        await GetMyself();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> Login(String email, String password) async {
    try {
      bool result = await UserWebService.login(email, password);
      if (result) {
        await GetMyself();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpdateUser(User user, XFile? xfile) async {
    try {
      bool result = await UserWebService.updateUser(user);
      if (result && myself.value.id != User.getEmptyUser().id) {
        myself.value.bio = user.bio;
        myself.value.username = user.username;
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpdateUserPhoto(XFile xfile) async {
    try {
      var result = await UserWebService.updateUserPhoto(xfile);
      if (!result) {
        return false;
      }
      userProfilePicture(Image.file(
        File(xfile.path),
        fit: BoxFit.cover,
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User> GetUser(String id) async {
    var result = await UserWebService.getUser(id);
    if (id == SharedPrefs().userId) {
      myself(result);
    }
    return result;
  }

  Future<User?> GetMyself() async {
    if (myself.value.id != "") {
      return myself.value;
    }
    if (SharedPrefs().userId.isEmpty) {
      return Future.error("no_data");
    }
    var user = User(bio: "", id: "", username: "");
    try {
      user = await UserWebService.getUser(SharedPrefs().userId);
    } catch (e) {
      debugPrint(e.toString());
    }
    myself(user);
    var contacts = await UserWebService.getUserContact(SharedPrefs().userId);
    myContacts(contacts);
    userProfilePicture(user.buildImage(fit: BoxFit.cover));
    return myself.value;
  }

  Future<bool> Logout() async {
    await SharedPrefs().clear();
    SharedPrefs().authToken = "";
    SharedPrefs().refreshToken = "";
    SharedPrefs().userId = "";
    SharedPrefs().logged = false;
    SharedPrefs().isFirstRun = false;
    myself(User.getEmptyUser());
    myContacts([]);
    return true;
  }

  Future<bool> DeleteMyself() async {
    bool result = await UserWebService.deleteMyself();
    if (!result) {
      return Future.error("failed_deleting_user");
    }
    await SharedPrefs().clear();
    SharedPrefs().authToken = "";
    SharedPrefs().refreshToken = "";
    SharedPrefs().userId = "";
    SharedPrefs().logged = false;
    SharedPrefs().isFirstRun = false;
    myself(User.getEmptyUser());
    myContacts([]);
    return true;
  }

  Future<bool> ResetPasswordStart(String email) async {
    try {
      var result = await UserWebService.resetPasswordStart(email);
      if (result.tokenId.isEmpty || result.userId.isEmpty) {
        return false;
      }
      SharedPrefs().confirmationToken = result.tokenId;
      SharedPrefs().userId = result.userId;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> ResetPasswordConfirm(String token) async {
    if (SharedPrefs().confirmationToken.isEmpty) {
      return false;
    }
    try {
      return await UserWebService.resetPasswordConfirm(
          token, SharedPrefs().confirmationToken);
    } catch (e) {
      return false;
    }
  }

  Future<bool> ResetPassword(String password) async {
    if (getToken().isEmpty) {
      return false;
    }
    if (SharedPrefs().confirmationToken.isEmpty ||
        SharedPrefs().userId.isEmpty) {
      return false;
    }
    try {
      return await UserWebService.resetPassword(getToken(),
          SharedPrefs().confirmationToken, password, SharedPrefs().userId);
    } catch (e) {
      return false;
    }
  }

  Future<List<UserContact>> getUserContact(String userId) async {
    try {
      return UserWebService.getUserContact(userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<UserContact> saveContact(UserContact contact) async {
    try {
      if (contact.id == null) {
        var newContact = await UserWebService.saveContact(contact);
        myContacts.add(newContact);
        return newContact;
      }
      var updatedContact = await UserWebService.updateContact(contact);
      for (int i = 0; i < myContacts.length; i++) {
        if (myContacts[i].id == updatedContact) {
          myContacts[i] = updatedContact;
        }
      }
      return updatedContact;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<bool> deleteContact(String contactId) async {
    try {
      var result = await UserWebService.deleteContact(contactId);
      if (result) {
        for (int i = 0; i < myContacts.length; i++) {
          if (myContacts[i].id == contactId) {
            myContacts.remove(i);
          }
        }
      }
      return result;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
