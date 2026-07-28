import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FreeShippingBarWidget extends StatelessWidget {
  final double subtotal;
  final double threshold;

  const FreeShippingBarWidget({
    super.key,
    required this.subtotal,
    this.threshold = 500.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (subtotal / threshold).clamp(0.0, 1.0);
    final remaining = (threshold - subtotal).clamp(0.0, threshold);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  progress >= 1.0
                      ? Icons.verified_outlined
                      : Icons.local_shipping_outlined,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  progress >= 1.0
                      ? 'Congratulations! You unlocked FREE Delivery 🚚🎉'
                      : 'Add ${remaining.toStringAsFixed(2)} EGP more for FREE Delivery!',
                  style: TextStyle(
                    color: progress >= 1.0
                        ? AppColors.primaryOrange
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF1E1E1E),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
