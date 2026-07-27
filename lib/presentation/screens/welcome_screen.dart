import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/core/theme/app_design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_pages.dart';
import '../../app/routes/app_routes.dart';
import '../widgets/custom_buttonwidget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondaryButtonColor.withOpacity(0.8),
                          AppColors.backgroundColor,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withOpacity(0.05),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Image.asset(
                          'assets/shop.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.shopping_bag_outlined,
                              size: 80,
                              color: AppColors.primaryOrange,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Welcome to\nE-Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Discover, shop, and personalize your\nexperience. Let's get started.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: "Create Account",
                  onPressed: () {
                    context.push(AppRoutes.signup);
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: "Log In",
                  backgroundColor: AppColors.secondaryButtonColor,
                  onPressed: () {
                    context.push(AppRoutes.login);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
