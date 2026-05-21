import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/data/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: restaurant.coverImageUrl != null && restaurant.coverImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: restaurant.coverImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.backgroundDark,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.backgroundDark,
                            child: Icon(Icons.restaurant_rounded, size: 48, color: AppColors.textTertiary),
                          ),
                        )
                      : Container(
                          color: AppColors.backgroundDark,
                          child: Icon(Icons.restaurant_rounded, size: 48, color: AppColors.textTertiary),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: restaurant.logoUrl!,
                            width: 56,
                            height: 56,
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
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.store_rounded, color: AppColors.textTertiary),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 18, color: AppColors.rating),
                                const SizedBox(width: 4),
                                Text(
                                  restaurant.rating.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  ' (${restaurant.reviewCount})',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (restaurant.estimatedDeliveryMinutes != null) ...[
                                  Icon(Icons.schedule_rounded, size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${restaurant.estimatedDeliveryMinutes} min',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Icon(Icons.delivery_dining_rounded, size: 16, color: AppColors.deliveryFee),
                                const SizedBox(width: 4),
                                Text(
                                  'Rs ${restaurant.deliveryFee.toInt()}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.deliveryFee,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
