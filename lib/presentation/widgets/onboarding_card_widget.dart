import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/domain/entities/product.dart';
import 'package:eshop_app/presentation/widgets/page_indicator_widget.dart';
import 'package:flutter/material.dart';

class OnboardingCardWidget extends StatelessWidget {
  final List<OnboardingEntity> items;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingCardWidget({
    super.key,
    required this.items,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item.imagePath,
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.handshake_outlined,
                        size: 90,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(item.title, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.description, textAlign: TextAlign.left),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: onSkip, child: const Text('Skip')),
              PageIndicatorWidget(
                count: items.length,
                currentIndex: currentIndex,
              ),
              TextButton(onPressed: onNext, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}
