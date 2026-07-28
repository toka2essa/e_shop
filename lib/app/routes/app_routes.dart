import 'package:eshop_app/presentation/screens/home.dart';
import 'package:eshop_app/presentation/screens/main_scaffold.dart';
import 'package:eshop_app/presentation/screens/cart_screen.dart';
import 'package:eshop_app/presentation/screens/settings_screen.dart';
import 'package:eshop_app/presentation/screens/products_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/create_acc.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/onboarding_screenOne.dart';
import '../../presentation/screens/otp_screen.dart';
import '../../presentation/screens/product_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import 'app_pages.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(path: AppRoutes.signup, builder: (context, state) => CreateAcc()),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return OtpScreen(email: email);
      },
    ),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.product,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
  ],
);
