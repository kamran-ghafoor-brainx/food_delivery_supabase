import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/data/models/restaurant.dart';
import 'package:food_delivery/di/dependency_injection_container.dart';
import 'package:food_delivery/presentation/screens/home/widgets/deal_card.dart';
import 'package:food_delivery/presentation/screens/home/widgets/restaurant_card.dart';
import 'package:food_delivery/presentation/screens/home/widgets/restaurant_detail_sheet.dart';
import 'package:food_delivery/presentation/view_models/home_viewmodel.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _vm;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<HomeViewModel>()) {
      Get.put(sl<HomeViewModel>());
    }
    _vm = Get.find<HomeViewModel>();
    _vm.loadDealsAndRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _vm.loadDealsAndRestaurants(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deliver to',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  'Current location',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Badge(
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (_vm.isLoading.value &&
                    _vm.deals.isEmpty &&
                    _vm.restaurants.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SliverToBoxAdapter(child: _buildContent(context));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (_vm.deals.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  'Deals for you',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _vm.deals.length,
                  itemBuilder: (context, index) {
                    return DealCard(deal: _vm.deals[index]);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Restaurants',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Obx(() {
          if (_vm.restaurants.isEmpty && !_vm.isLoading.value) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No restaurants yet',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: _vm.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _vm.restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () => _onRestaurantTap(restaurant),
              );
            },
          );
        }),
      ],
    );
  }

  Future<void> _onRestaurantTap(RestaurantModel restaurant) async {
    await _vm.openRestaurant(restaurant);
    if (!mounted) return;
    final selected = _vm.selectedRestaurant.value;
    if (selected == null) return;
    await RestaurantDetailSheet.show(
      context,
      restaurant: selected,
      categories: _vm.dishCategories.toList(),
      dishes: _vm.dishes.toList(),
      isLoading: _vm.isLoadingRestaurantDetail.value,
      getDishesForCategory: _vm.getDishesForCategory,
    );
    _vm.clearRestaurantDetail();
  }
}
