import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/core/theme/app_design.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_buttonwidget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/shop.png',
                      width: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shopping_bag_outlined,
                          size: 100,
                          color: AppColors.textSecondary,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              const Text(
                "Welcome to\nE-Shop",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppDesign.titleFontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: AppDesign.spacingSmall),

              const Text(
                "Discover, shop, and personalize your\nexperience. Let's get started.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDesign.subTitleFontSize,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              CustomButton(
                text: "Create Account",
                onPressed: () {
                },
              ),

              const SizedBox(height: AppDesign.spacingSmall),

              CustomButton(
                text: "Log In",
                backgroundColor: AppColors.secondaryButtonColor,
                onPressed: () {
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}