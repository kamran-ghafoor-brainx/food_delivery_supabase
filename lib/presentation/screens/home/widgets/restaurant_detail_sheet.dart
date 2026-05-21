import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/dish_category.dart';
import 'package:food_delivery/data/models/restaurant.dart';
class RestaurantDetailSheet extends StatelessWidget {
  final RestaurantModel restaurant;
  final List<DishCategoryModel> categories;
  final List<DishModel> dishes;
  final bool isLoading;
  final List<DishModel> Function(String? categoryId) getDishesForCategory;

  const RestaurantDetailSheet({
    super.key,
    required this.restaurant,
    required this.categories,
    required this.dishes,
    required this.isLoading,
    required this.getDishesForCategory,
  });

  static Future<void> show(
    BuildContext context, {
    required RestaurantModel restaurant,
    required List<DishCategoryModel> categories,
    required List<DishModel> dishes,
    required bool isLoading,
    required List<DishModel> Function(String? categoryId) getDishesForCategory,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RestaurantDetailSheet(
        restaurant: restaurant,
        categories: categories,
        dishes: dishes,
        isLoading: isLoading,
        getDishesForCategory: getDishesForCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const _HandleBar(),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: _Header(restaurant: restaurant),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                          child: Text(
                            'Menu',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                      ...categories.map((cat) {
                        final list = getDishesForCategory(cat.id);
                        if (list.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                        return SliverToBoxAdapter(
                          child: _CategorySection(
                            categoryName: cat.name,
                            dishList: list,
                          ),
                        );
                      }),
                      SliverToBoxAdapter(
                        child: _CategorySection(
                          categoryName: 'Other',
                          dishList: getDishesForCategory(null),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HandleBar extends StatelessWidget {
  const _HandleBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final RestaurantModel restaurant;

  const _Header({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (restaurant.coverImageUrl != null && restaurant.coverImageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: restaurant.coverImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.backgroundDark),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.backgroundDark,
                    child: Icon(Icons.restaurant_rounded, size: 48, color: AppColors.textTertiary),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.logoUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.backgroundDark),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.backgroundDark,
                      child: Icon(Icons.store_rounded, color: AppColors.textTertiary),
                    ),
                  ),
                )
              else
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.store_rounded, size: 32, color: AppColors.textTertiary),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 20, color: AppColors.rating),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          ' (${restaurant.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (restaurant.estimatedDeliveryMinutes != null)
                      Text(
                        '${restaurant.estimatedDeliveryMinutes} min • Rs ${restaurant.deliveryFee.toInt()} delivery',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (restaurant.description != null && restaurant.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              restaurant.description!,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String categoryName;
  final List<DishModel> dishList;

  const _CategorySection({required this.categoryName, required this.dishList});

  @override
  Widget build(BuildContext context) {
    if (dishList.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          ...dishList.map((d) => _DishTile(dish: d)),
        ],
      ),
    );
  }
}

class _DishTile extends StatelessWidget {
  final DishModel dish;

  const _DishTile({required this.dish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 88,
              height: 88,
              child: dish.imageUrl != null && dish.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: dish.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.backgroundDark),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.backgroundDark,
                        child: Icon(Icons.restaurant_rounded, color: AppColors.textTertiary),
                      ),
                    )
                  : Container(
                      color: AppColors.backgroundDark,
                      child: Icon(Icons.restaurant_rounded, color: AppColors.textTertiary),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dish.isBestseller)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Bestseller',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                Text(
                  dish.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dish.description != null && dish.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    dish.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Rs ${dish.displayPrice.toInt()}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (dish.hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Rs ${dish.price.toInt()}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              foregroundColor: AppColors.primary,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
          ),
        ],
      ),
    );
  }
}
