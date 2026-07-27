import 'dart:math' as math;

import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:eshop_app/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProductsSectionWidget extends StatelessWidget {
  const HomeProductsSectionWidget({super.key});

  static const _previewCount = 4;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        const heading = Text(
          'Featured products',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );

        if (state.action == AppAction.getProducts &&
            state.status == AppStatus.loading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              SizedBox(height: 12),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ],
          );
        }

        if (state.action == AppAction.getProducts &&
            state.status == AppStatus.failure) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              const SizedBox(height: 12),
              Text(
                state.message ?? 'Could not load products.',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: () => context.read<AppCubit>().getProducts(),
                child: const Text('Try again'),
              ),
            ],
          );
        }

        if (state.products.isEmpty) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              SizedBox(height: 12),
              Text(
                'No products available right now.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          );
        }

        final products = state.products.take(_previewCount).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading,
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: math.min(products.length, _previewCount),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .58,
              ),
              itemBuilder: (context, index) => ProductCard(
                product: products[index],
              ),
            ),
          ],
        );
      },
    );
  }
}
