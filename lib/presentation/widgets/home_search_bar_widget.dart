import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeSearchBarWidget extends StatelessWidget {
  const HomeSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryButtonColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: AppColors.textSecondary),
          hintText: 'Search Anything...',
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          border: InputBorder.none,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                child: VerticalDivider(
                  color: AppColors.textSecondary,
                  thickness: 1,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.mic_none, color: AppColors.primaryOrange),
            ],
          ),
        ),
      ),
    );
  }
}
