import 'dart:io';

import 'package:food_delivery/core/constants/supabase_constants.dart';
import 'package:food_delivery/data/models/deal.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/dish_category.dart';
import 'package:food_delivery/data/models/restaurant.dart';
import 'package:food_delivery/data/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseManager();

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadProfileImage(File image) async {
    try {
      final path = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final url = await _supabase.storage
          .from(SupabaseConstants.storageImages)
          .upload("${SupabaseConstants.storageProfileImages}/$path", image);
      return url;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> insertUserData(UserModel user) async {
    try {
      await _supabase.from(SupabaseConstants.tableUsers).insert(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (authResponse.user != null) {
        print("authResponse.user!.id: ${authResponse.user!.id}");
        final user = await getUserById(authResponse.user!.id);
        return user;
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getUserId() async {
    try {
      final userResponse = await _supabase.auth.getUser();
      return userResponse.user?.id ?? '';
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final userResponse = await _supabase
          .from(SupabaseConstants.tableUsers)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (userResponse == null) return null;
      return UserModel.fromJson(userResponse);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final res = await _supabase
          .from(SupabaseConstants.tableRestaurants)
          .select()
          .eq('is_active', true)
          .order('rating', ascending: false)
          .order('name');
      return (res as List)
          .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    try {
      final res = await _supabase
          .from(SupabaseConstants.tableRestaurants)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (res == null) return null;
      return RestaurantModel.fromJson(Map<String, dynamic>.from(res));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DealModel>> getDeals() async {
    try {
      final now = DateTime.now().toIso8601String();
      final res = await _supabase
          .from(SupabaseConstants.tableDeals)
          .select()
          .eq('is_active', true)
          .lte('valid_from', now)
          .gte('valid_until', now)
          .order('sort_order')
          .order('valid_until');
      return (res as List)
          .map((e) => DealModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DishCategoryModel>> getDishCategoriesByRestaurant(
    String restaurantId,
  ) async {
    try {
      final res = await _supabase
          .from(SupabaseConstants.tableDishCategories)
          .select()
          .eq('restaurant_id', restaurantId)
          .order('sort_order')
          .order('name');
      return (res as List)
          .map((e) => DishCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DishModel>> getDishesByRestaurant(String restaurantId) async {
    try {
      final res = await _supabase
          .from(SupabaseConstants.tableDishes)
          .select()
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .order('sort_order')
          .order('name');
      return (res as List)
          .map((e) => DishModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
