import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';
import 'package:get/get.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPressed;

  const CustomAlert({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: context.theme.textTheme.titleLarge),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: AppColors.textPrimary),
                ),
              ],
            ),

            Text(message, style: context.theme.textTheme.bodyMedium),

            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(text: 'Ok', onPressed: onPressed),
            ),
          ],
        ),
      ),
    );
  }
}
