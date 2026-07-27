import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:eshop_app/presentation/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppCubit>().getProductDetails(widget.productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state.status == AppStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            );
          }

          if (state.status == AppStatus.failure) {
            return ErrorView(
              message: state.message ?? 'Something went wrong',
              onRetry: () =>
                  context.read<AppCubit>().getProductDetails(widget.productId),
            );
          }

          if (state.status == AppStatus.success) {
            final product = state.selectedProduct;
            if (product == null) {
              return const SizedBox.shrink();
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  backgroundColor: AppColors.backgroundColor,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: AppColors.textSecondary,
                            ),
                          ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${product.price} ',
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 120), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomSheet: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state.status == AppStatus.success &&
              state.selectedProduct != null) {
            return Container(
              padding: const EdgeInsets.all(24),
              color: AppColors.backgroundColor,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add to cart logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
