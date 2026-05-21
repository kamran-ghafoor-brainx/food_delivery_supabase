import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? 56.0;
    final borderRadiusValue = borderRadius ?? 12.0;

    if (isOutlined) {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: onPressed == null ? AppColors.buttonDisabled : AppColors.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusValue),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Text(
                  text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: onPressed == null ? AppColors.buttonDisabled : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
          foregroundColor: textColor ?? AppColors.textLight,
          elevation: 0,
          disabledBackgroundColor: AppColors.buttonDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textLight),
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor ?? AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
