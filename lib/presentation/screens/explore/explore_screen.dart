import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_rounded, size: 80, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'Explore',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search restaurants & dishes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textTertiary,
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
