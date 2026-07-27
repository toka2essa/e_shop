import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'E_shop',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 12),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.primaryOrange,
                    size: 22,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
