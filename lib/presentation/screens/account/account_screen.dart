import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/routes/app_routes.dart';
import 'package:food_delivery/di/dependency_injection_container.dart';
import 'package:food_delivery/domain/managers/supabase_manager.dart';
import 'package:food_delivery/presentation/view_models/auth_viewmodel.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = sl<AuthViewModel>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Obx(() {
                final user = authVm.user;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.backgroundDark,
                          backgroundImage: user.profileImage.isNotEmpty
                              ? NetworkImage(user.profileImage)
                              : null,
                          child: user.profileImage.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 36,
                                  color: AppColors.textTertiary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName
                                    : 'Guest',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              if (user.email.isNotEmpty)
                                Text(
                                  user.email,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.logout_rounded, color: AppColors.error),
                title: Text(
                  'Log out',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  await sl<SupabaseManager>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
