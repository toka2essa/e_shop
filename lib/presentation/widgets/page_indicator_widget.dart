import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicatorWidget({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? Colors.white54
                : AppColors.textPrimary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
