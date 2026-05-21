import 'dart:io';

import 'package:food_delivery/data/models/user.dart';
import 'package:food_delivery/di/dependency_injection_container.dart';
import 'package:food_delivery/domain/managers/supabase_manager.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthViewModel extends GetxController {
  final SupabaseManager _supabaseManager = sl<SupabaseManager>();
  final RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;
  final Rx<UserModel> _user = UserModel().obs;
  UserModel get user => _user.value;
  set user(UserModel value) {
    _user.value = value;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    File? profileImage,
    required void Function() onSuccess,
    required void Function({required String error}) onError,
  }) async {
    try {
      _isLoading.value = true;
      await _supabaseManager.signUp(email, password);
      if (profileImage != null) {
        final profileImageUrl = await _supabaseManager.uploadProfileImage(
          profileImage,
        );
        final userId = await _supabaseManager.getUserId();
        await _supabaseManager.insertUserData(
          UserModel(
            id: userId,
            email: email,
            password: password,
            fullName: fullName,
            profileImage: profileImageUrl,
          ),
        );
        onSuccess.call();
      }
    } catch (e) {
      onError(error: e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required void Function() onSuccess,
    required void Function({required String error}) onError,
  }) async {
    try {
      _isLoading.value = true;
      final user = await _supabaseManager.login(email, password);
      if (user != null) {
        this.user = user;
      }
      print("user: $user");
      print("user id: ${user?.id}");
      print("user email: ${user?.email}");
      print("user full name: ${user?.fullName}");
      print("user profile image: ${user?.profileImage}");
      onSuccess.call();
    } catch (e) {
      onError(error: e.toString());
    } finally {
      _isLoading.value = false;
    }
  }
}
