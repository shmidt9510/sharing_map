import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/services/core/models/api_response.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/services/address_service.dart';
import 'package:sharing_map/services/user_service.dart';
import 'package:sharing_map/utils/shared.dart';

/// Authentication and signup result states
enum AuthResult {
  success,
  invalidEmail,
  emailTaken,
  invalidCredentials,
  networkError,
  timeout,
  unknownError,
}

extension AuthResultExtension on AuthResult {
  String get message {
    switch (this) {
      case AuthResult.success:
        return 'Успех';
      case AuthResult.invalidEmail:
        return 'Неверный формате email';
      case AuthResult.emailTaken:
        return 'Пользователь с таким email уже зарегестрирован. Попробуйте сброс пароля';
      case AuthResult.invalidCredentials:
        return 'Неверная почта или пароль';
      case AuthResult.networkError:
        return 'Сервер недоступен, попробуйте позднее';
      case AuthResult.timeout:
        return 'Сервер недоступен, попробуйте позднее.';
      case AuthResult.unknownError:
        return 'Сервер недоступен: попробуйте позднее';
    }
  }

  bool get isSuccess => this == AuthResult.success;
}

/// User controller managing authentication and user data
class UserController extends GetxController {
  final UserService _userService = UserService();
  final AddressService _addressService = AddressService();

  // User data
  final myself = Rx<User>(User.getEmptyUser());
  final myAddresses = <Address>[].obs;
  final myContacts = <UserContact>[].obs;
  final userProfilePicture = Rx<Widget>(
    User.getEmptyUser().buildImage(fit: BoxFit.cover),
  );

  // Loading states
  final isLoadingUser = false.obs;
  final isLoadingAddresses = false.obs;
  final isLoadingContacts = false.obs;
  final isUpdatingProfile = false.obs;

  // Temporary tokens for verification flows
  final _confirmationToken = ''.obs;
  final _verificationCode = ''.obs;

  // Getters
  bool get isLoggedIn => SharedPrefs().logged && myself.value.id.isNotEmpty;
  bool get hasProfileData => myself.value.id != User.getEmptyUser().id;
  String get userId => SharedPrefs().userId;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    if (SharedPrefs().logged && SharedPrefs().userId.isNotEmpty) {
      try {
        await getMyself();
      } catch (e) {
        debugPrint('❌ Failed to initialize user: $e');
      }
    }
  }

  // ==================== Authentication ====================

  /// Check if user is authorized
  Future<bool> checkAuthorization() async {
    if (SharedPrefs().userId.isEmpty) {
      debugPrint('⚠️ No user ID found');
      return false;
    }

    try {
      final isAuth = await _userService.isAuth();
      if (isAuth) {
        SharedPrefs().isFirstRun = false;
        SharedPrefs().logged = true;
        debugPrint('✅ User is authorized');
      } else {
        debugPrint('⚠️ User is not authorized');
      }
      return isAuth;
    } catch (e) {
      debugPrint('❌ Authorization check failed: $e');
      return false;
    }
  }

  /// Sign up new user
  Future<AuthResult> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      debugPrint('📝 Signing up user: $email');

      final result = await _userService
          .signup(email, username, password)
          .timeout(const Duration(seconds: 20));

      if (result.isEmpty) {
        return AuthResult.unknownError;
      }

      if (result == 'email_taken') {
        return AuthResult.emailTaken;
      }

      if (result == 'invalid_email') {
        return AuthResult.invalidEmail;
      }

      // Store confirmation token
      _confirmationToken.value = result;
      SharedPrefs().confirmationToken = result;

      debugPrint('✅ Signup successful, confirmation token received');
      return AuthResult.success;
    } on TimeoutException {
      return AuthResult.timeout;
    } on ApiException catch (e) {
      if (e.code == 'network_error') {
        return AuthResult.networkError;
      }
      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Signup error: $e');
      return AuthResult.unknownError;
    }
  }

  /// Confirm signup with verification code
  Future<AuthResult> signupConfirm(String verificationCode) async {
    if (_confirmationToken.value.isEmpty) {
      debugPrint('⚠️ No confirmation token found');
      return AuthResult.unknownError;
    }

    try {
      debugPrint('🔐 Confirming signup with code');

      final success = await _userService.signupConfirm(
        verificationCode,
        _confirmationToken.value,
      );

      if (success) {
        await getMyself();
        _confirmationToken.value = '';
        SharedPrefs().confirmationToken = '';
        debugPrint('✅ Signup confirmed successfully');
        return AuthResult.success;
      }

      return AuthResult.unknownError;
    } on ApiException catch (e) {
      debugPrint('❌ Signup confirmation failed: ${e.code}');
      if (e.code == 'network_error') {
        return AuthResult.networkError;
      }
      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Signup confirmation error: $e');
      return AuthResult.unknownError;
    }
  }

  /// Login user
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔑 Logging in user: $email');

      final success = await _userService.login(email, password);

      if (success) {
        await getMyself();
        debugPrint('✅ Login successful');
        return AuthResult.success;
      }

      return AuthResult.invalidCredentials;
    } on ApiException catch (e) {
      debugPrint('❌ Login failed: ${e.code}');

      if (e.code == 'network_error') {
        return AuthResult.networkError;
      }
      if (e.code == 'unauthorized') {
        return AuthResult.invalidCredentials;
      }
      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return AuthResult.unknownError;
    }
  }

  /// Logout user
  Future<void> logout() async {
    debugPrint('👋 Logging out user');

    await _clearUserData();

    debugPrint('✅ Logout successful');
  }

  /// Delete user account
  Future<bool> deleteMyself() async {
    try {
      debugPrint('🗑️ Deleting user account');

      final success = await _userService.deleteMyself();

      if (success) {
        await _clearUserData();
        debugPrint('✅ Account deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to delete account: $e');
      return false;
    }
  }

  Future<User> getMyself({bool forceRefresh = false}) async {
    if (!forceRefresh && hasProfileData) {
      debugPrint('✅ Returning cached user data');
      return myself.value;
    }

    if (SharedPrefs().userId.isEmpty) {
      throw Exception('no_user_id');
    }

    isLoadingUser.value = true;

    try {
      debugPrint('📥 Fetching user data for ${SharedPrefs().userId}');

      // Fetch user, addresses, and contacts in parallel
      final results = await Future.wait([
        _userService.getUser(SharedPrefs().userId),
        _fetchMyAddresses(),
        _fetchMyContacts(),
      ]);

      final user = results[0] as User;

      myself.value = user;
      userProfilePicture.value = user.buildImage(fit: BoxFit.cover);

      debugPrint('✅ User data loaded successfully');
      return user;
    } catch (e) {
      debugPrint('❌ Failed to fetch user data: $e');
      rethrow;
    } finally {
      isLoadingUser.value = false;
    }
  }

  /// Get user by ID
  Future<User> getUser(String userId) async {
    try {
      final user = await _userService.getUser(userId);

      // Update myself if fetching own data
      if (userId == SharedPrefs().userId) {
        myself.value = user;
        userProfilePicture.value = user.buildImage(fit: BoxFit.cover);
      }

      return user;
    } catch (e) {
      debugPrint('❌ Failed to fetch user $userId: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<bool> updateUser(User user) async {
    isUpdatingProfile.value = true;

    try {
      debugPrint('📝 Updating user profile');

      final success = await _userService.updateUser(user);

      if (success && hasProfileData) {
        myself.value.bio = user.bio;
        myself.value.username = user.username;
        debugPrint('✅ User profile updated');
      }

      return success;
    } catch (e) {
      debugPrint('❌ Failed to update user: $e');
      return false;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  /// Update user profile photo
  Future<bool> updateUserPhoto(XFile photoFile) async {
    try {
      debugPrint('📸 Uploading profile photo');

      final success = await _userService.updateUserPhoto(photoFile);

      if (success) {
        userProfilePicture.value = Image.file(
          File(photoFile.path),
          fit: BoxFit.cover,
        );
        debugPrint('✅ Profile photo updated');
      }

      return success;
    } catch (e) {
      debugPrint('❌ Failed to update photo: $e');
      return false;
    }
  }

  // ==================== Addresses ====================

  Future<void> _fetchMyAddresses() async {
    isLoadingAddresses.value = true;

    try {
      final addresses = await _addressService.getAllAddresses();
      myAddresses.value = addresses;
      debugPrint('✅ Loaded ${addresses.length} addresses');
    } catch (e) {
      throw Exception("failed_to_fetch_addresses");
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  /// Refresh user addresses
  Future<void> refreshAddresses() async {
    await _fetchMyAddresses();
  }

  // ==================== Contacts ====================

  Future<void> _fetchMyContacts() async {
    if (SharedPrefs().userId.isEmpty) return;

    isLoadingContacts.value = true;

    try {
      final contacts = await _userService.getUserContact(SharedPrefs().userId);
      myContacts.value = contacts;
      debugPrint('✅ Loaded ${contacts.length} contacts');
    } catch (e) {
      throw Exception("failed_to_fetch_contacts");
    } finally {
      isLoadingContacts.value = false;
    }
  }

  /// Get contacts for a user
  Future<List<UserContact>> getUserContacts(String userId) async {
    try {
      return await _userService.getUserContact(userId);
    } catch (e) {
      debugPrint('❌ Failed to get contacts for user $userId: $e');
      rethrow;
    }
  }

  /// Save or update contact
  Future<UserContact> saveContact(UserContact contact) async {
    try {
      UserContact savedContact;

      if (contact.id == null || contact.id!.isEmpty) {
        // Create new contact
        debugPrint('📝 Creating new contact');
        savedContact = await _userService.saveContact(contact);
        myContacts.add(savedContact);
      } else {
        // Update existing contact
        debugPrint('📝 Updating contact ${contact.id}');
        savedContact = await _userService.updateContact(contact);

        final index = myContacts.indexWhere((c) => c.id == savedContact.id);
        if (index != -1) {
          myContacts[index] = savedContact;
        }
      }

      debugPrint('✅ Contact saved successfully');
      return savedContact;
    } catch (e) {
      debugPrint('❌ Failed to save contact: $e');
      rethrow;
    }
  }

  /// Delete contact
  Future<bool> deleteContact(String contactId) async {
    try {
      debugPrint('🗑️ Deleting contact $contactId');

      final success = await _userService.deleteContact(contactId);

      if (success) {
        myContacts.removeWhere((c) => c.id == contactId);
        debugPrint('✅ Contact deleted');
      }

      return success;
    } catch (e) {
      debugPrint('❌ Failed to delete contact: $e');
      return false;
    }
  }

  // ==================== Password Reset ====================

  /// Start password reset process
  Future<AuthResult> resetPasswordStart(String email) async {
    try {
      debugPrint('🔐 Starting password reset for $email');

      final result = await _userService.resetPasswordStart(email);

      if (result.tokenId.isEmpty || result.userId.isEmpty) {
        return AuthResult.unknownError;
      }

      _confirmationToken.value = result.tokenId;
      SharedPrefs().confirmationToken = result.tokenId;
      SharedPrefs().userId = result.userId;

      debugPrint('✅ Password reset token sent');
      return AuthResult.success;
    } on ApiException catch (e) {
      debugPrint('❌ Password reset start failed: ${e.code}');

      if (e.code == 'network_error') {
        return AuthResult.networkError;
      }
      if (e.code == 'not_found') {
        return AuthResult.invalidEmail;
      }
      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      return AuthResult.unknownError;
    }
  }

  /// Confirm password reset with code
  Future<AuthResult> resetPasswordConfirm(String verificationCode) async {
    if (_confirmationToken.value.isEmpty) {
      return AuthResult.unknownError;
    }

    try {
      debugPrint('🔐 Confirming password reset code');

      final success = await _userService.resetPasswordConfirm(
        verificationCode,
        _confirmationToken.value,
      );

      if (success) {
        _verificationCode.value = verificationCode;
        debugPrint('✅ Password reset code confirmed');
        return AuthResult.success;
      }

      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Password reset confirmation failed: $e');
      return AuthResult.unknownError;
    }
  }

  /// Complete password reset
  Future<AuthResult> resetPassword(String newPassword) async {
    if (_verificationCode.value.isEmpty || _confirmationToken.value.isEmpty) {
      return AuthResult.unknownError;
    }

    if (SharedPrefs().userId.isEmpty) {
      return AuthResult.unknownError;
    }

    try {
      debugPrint('🔐 Setting new password');

      final success = await _userService.resetPassword(
        _verificationCode.value,
        _confirmationToken.value,
        newPassword,
        SharedPrefs().userId,
      );

      if (success) {
        _verificationCode.value = '';
        _confirmationToken.value = '';
        SharedPrefs().confirmationToken = '';
        debugPrint('✅ Password reset successful');
        return AuthResult.success;
      }

      return AuthResult.unknownError;
    } catch (e) {
      debugPrint('❌ Password reset failed: $e');
      return AuthResult.unknownError;
    }
  }

  // ==================== Private Helpers ====================

  Future<void> _clearUserData() async {
    await SharedPrefs().clear();
    SharedPrefs().authToken = '';
    SharedPrefs().refreshToken = '';
    SharedPrefs().userId = '';
    SharedPrefs().logged = false;
    SharedPrefs().isFirstRun = false;
    SharedPrefs().confirmationToken = '';

    myself.value = User.getEmptyUser();
    myContacts.clear();
    myAddresses.clear();
    userProfilePicture.value =
        User.getEmptyUser().buildImage(fit: BoxFit.cover);
    _confirmationToken.value = '';
    _verificationCode.value = '';
  }

  @override
  void onClose() {
    debugPrint('🔴 UserController disposed');
    super.onClose();
  }
}
