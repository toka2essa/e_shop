import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/products/products_cubit.dart';
import 'package:eshop_app/presentation/cubit/products/products_state.dart';
import '../../widgets/product_card.dart';
import '../../widgets/error_view.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: AppColors.textPrimary, size: 20),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Products',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading || state is ProductsInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            );
          }

          if (state is ProductsError) {
            return ErrorView(
              onRetry: () => context.read<ProductsCubit>().getProducts(),
              message: state.message,
            );
          }

          if (state is ProductsLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primaryOrange,
                onRefresh: () => context.read<ProductsCubit>().getProducts(),
                child: ListView(
                  children: const [
                    SizedBox(height: 100),
                    Center(
                      child: Text(
                        'No products available.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () => context.read<ProductsCubit>().getProducts(),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
