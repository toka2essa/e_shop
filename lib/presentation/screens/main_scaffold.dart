import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: navigationShell,
      bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final totalItems = state.cartItems.fold<int>(
            0,
            (sum, item) => sum + item.quantity,
          );

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border(
                top: BorderSide(color: Colors.white10),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              selectedItemColor: AppColors.primaryOrange,
              unselectedItemColor: AppColors.textSecondary,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(index),
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: totalItems > 0,
                    label: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: AppColors.primaryOrange,
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: totalItems > 0,
                    label: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: AppColors.primaryOrange,
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
