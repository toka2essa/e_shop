import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/core/network/rest/auth_token_storage.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/widgets/logo_painter.dart';
import 'package:eshop_app/presentation/widgets/splash_headerText.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _onboardingCompletedKey = 'onboarding_completed';

  @override
  void initState() {
    super.initState();
    _decideStartRoute();
  }

  Future<void> _decideStartRoute() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final preferences = await SharedPreferences.getInstance();
    final onboardingCompleted =
        preferences.getBool(_onboardingCompletedKey) ?? false;
    final token = await AuthTokenStorage().read();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(AppRoutes.home);
    } else if (onboardingCompleted) {
      context.go(AppRoutes.welcome);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
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
