import 'package:flutter/material.dart';
import 'package:eshop_app/core/theme/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cart', style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
        ),
      ),
    );
  }
}
