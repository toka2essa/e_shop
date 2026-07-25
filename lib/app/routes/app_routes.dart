import 'package:eshop_app/presentation/screens/main_scaffold.dart';
import 'package:eshop_app/presentation/screens/pages/cart_screen.dart';
import 'package:eshop_app/presentation/screens/pages/settings_screen.dart';
import 'package:eshop_app/presentation/screens/pages/products_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection_container.dart';
import '../../presentation/cubit/auth/auth_cubit.dart';
import '../../presentation/cubit/products/products_cubit.dart';
import '../../presentation/cubit/products/product_details_cubit.dart';
import '../../presentation/cubit/login/login_cubit.dart';
import '../../presentation/screens/pages/create_acc.dart';
import '../../presentation/screens/pages/login_screen.dart';
import '../../presentation/screens/pages/otp_screen.dart';
import '../../presentation/screens/pages/product_screen.dart';
import '../../presentation/screens/pages/welcome_screen.dart';
import 'app_pages.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: CreateAcc(),
      ),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: OtpScreen(email: email),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<LoginCubit>(),
        child: LoginScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                create: (context) => sl<ProductsCubit>()..getProducts(),
                child: const ProductScreen(),
              ),
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
      path: AppRoutes.productDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => sl<ProductDetailsCubit>()..getProductDetails(id),
          child: const ProductDetailsScreen(),
        );
      },
    ),
  ],
);
