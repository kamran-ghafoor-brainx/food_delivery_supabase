import 'package:food_delivery/data/models/deal.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/dish_category.dart';
import 'package:food_delivery/data/models/restaurant.dart';
import 'package:food_delivery/di/dependency_injection_container.dart';
import 'package:food_delivery/domain/managers/supabase_manager.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeViewModel extends GetxController {
  final SupabaseManager _supabaseManager = sl<SupabaseManager>();

  final RxBool isLoading = false.obs;
  final RxList<DealModel> deals = <DealModel>[].obs;
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxList<DishCategoryModel> dishCategories = <DishCategoryModel>[].obs;
  final RxList<DishModel> dishes = <DishModel>[].obs;
  final Rx<RestaurantModel?> selectedRestaurant = Rx<RestaurantModel?>(null);
  final RxBool isLoadingRestaurantDetail = false.obs;

  Future<void> loadDealsAndRestaurants() async {
    isLoading.value = true;
    try {
      await Future.wait([loadDeals(), loadRestaurants()]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDeals() async {
    final list = await _supabaseManager.getDeals();
    deals.value = list;
  }

  Future<void> loadRestaurants() async {
    final list = await _supabaseManager.getRestaurants();
    restaurants.value = list;
  }

  Future<void> openRestaurant(RestaurantModel restaurant) async {
    selectedRestaurant.value = restaurant;
    isLoadingRestaurantDetail.value = true;
    try {
      final results = await Future.wait([
        _supabaseManager.getDishCategoriesByRestaurant(restaurant.id),
        _supabaseManager.getDishesByRestaurant(restaurant.id),
      ]);
      dishCategories.value = results[0] as List<DishCategoryModel>;
      dishes.value = results[1] as List<DishModel>;
    } finally {
      isLoadingRestaurantDetail.value = false;
    }
  }

  void clearRestaurantDetail() {
    selectedRestaurant.value = null;
    dishCategories.clear();
    dishes.clear();
  }

  List<DishModel> getDishesForCategory(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return dishes
          .where((d) => d.categoryId == null || d.categoryId!.isEmpty)
          .toList();
    }
    return dishes.where((d) => d.categoryId == categoryId).toList();
  }

  List<DishModel> get dishesWithoutCategory => dishes
      .where((d) => d.categoryId == null || d.categoryId!.isEmpty)
      .toList();
}
