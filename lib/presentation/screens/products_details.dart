import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/domain/entities/product.dart';
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
  Product? _cachedProduct;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppCubit>().getProductDetails(widget.productId);
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state.action == AppAction.addToCart && state.cartMessage != null) {
            _showSnackBar(state.cartMessage!);
          }
          if (state.selectedProduct != null) {
            setState(() {
              _cachedProduct = state.selectedProduct;
            });
          }
        },
        builder: (context, state) {
          final product = state.selectedProduct ?? _cachedProduct;

          if (state.status == AppStatus.loading && product == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            );
          }

          if (state.status == AppStatus.failure && product == null) {
            return ErrorView(
              message: state.message ?? 'Something went wrong',
              onRetry: () =>
                  context.read<AppCubit>().getProductDetails(widget.productId),
            );
          }

          if (product != null) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 380,
                  pinned: true,
                  backgroundColor: AppColors.backgroundColor,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 90,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 90,
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${product.price.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 22,
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
                          product.description.isNotEmpty
                              ? product.description
                              : 'High quality product with premium features.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryOrange),
          );
        },
      ),
      bottomSheet: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final product = state.selectedProduct ?? _cachedProduct;
          if (product != null) {
            return Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.backgroundColor,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: state.isCartLoading
                        ? null
                        : () {
                            context.read<AppCubit>().addToCart(
                              productId: product.id,
                              quantity: 1,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    icon: state.isCartLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.shopping_bag_outlined),
                    label: Text(
                      state.isCartLoading ? 'Adding...' : 'Add to Cart',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
