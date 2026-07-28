import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/injection_container.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/categories_section_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_products_section_widget.dart';
import '../widgets/home_search_bar_widget.dart';
import '../widgets/shoe_promo_banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<AppCubit>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoriesCubit>()..fetchCategories(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HomeHeaderWidget(),
                SizedBox(height: 20),
                HomeSearchBarWidget(),
                SizedBox(height: 24),
                ShoePromoBannerWidget(),
                SizedBox(height: 24),
                CategoriesSectionWidget(),
                SizedBox(height: 24),
                HomeProductsSectionWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
