import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/widgets/logo_painter.dart';
import 'package:eshop_app/presentation/widgets/splash_headerText.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go(AppRoutes.onboarding);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LogoCard(),
              SizedBox(height: 16),
              SplashHeaderText(),
            ],
          ),
        ),
      ),
    );
  }
}
