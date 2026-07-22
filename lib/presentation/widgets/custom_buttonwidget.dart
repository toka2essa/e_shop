import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/core/theme/app_design.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryOrange,
    this.textColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDesign.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.buttonRadius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: AppDesign.buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}