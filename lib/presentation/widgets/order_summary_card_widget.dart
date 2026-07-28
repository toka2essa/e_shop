import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OrderSummaryCardWidget extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discountAmount;
  final double finalTotal;
  final bool isFreeShipping;

  const OrderSummaryCardWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discountAmount,
    required this.finalTotal,
    required this.isFreeShipping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
          const Text(
            'Order Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _buildSummaryRow('Subtotal', '${subtotal.toStringAsFixed(2)} EGP'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Delivery Fee',
            isFreeShipping
                ? 'FREE'
                : '${deliveryFee.toStringAsFixed(2)} EGP',
            valueColor: isFreeShipping ? Colors.greenAccent : Colors.white,
          ),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              '- ${discountAmount.toStringAsFixed(2)} EGP',
              valueColor: Colors.greenAccent,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${finalTotal.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
