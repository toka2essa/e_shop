import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  static const _visuals = [
    _CategoryVisual(Icons.directions_run, Color(0xFFFB8C32)),
    _CategoryVisual(Icons.hiking, Color(0xFF4DA3D9)),
    _CategoryVisual(Icons.child_friendly, Color(0xFFB56DA6)),
    _CategoryVisual(Icons.shopping_bag_outlined, Color(0xFF54BFA8)),
    _CategoryVisual(Icons.sports_soccer, Color(0xFF9B7BEA)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryOrange,
              ),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                  ),
                );
              } else if (state is CategoriesLoaded) {
                if (state.categories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories available right now.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final visual = _visuals[index % _visuals.length];
                    return Container(
                      width: 108,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryButtonColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CategoryThumbnail(
                            imageUrl: category.imageUrl,
                            visual: visual,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is CategoriesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 18),
        _ExploreProductsButton(
          onPressed: () => context.push(AppRoutes.product),
        ),
      ],
    );
  }
}

class _ExploreProductsButton extends StatelessWidget {
  const _ExploreProductsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryOrange.withOpacity(.7)),
            color: AppColors.primaryOrange.withOpacity(.1),
          ),
          child: const Row(
            children: [
              Icon(Icons.grid_view_rounded, color: AppColors.primaryOrange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Explore all products',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: AppColors.primaryOrange),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryThumbnail extends StatelessWidget {
  const _CategoryThumbnail({required this.imageUrl, required this.visual});

  final String? imageUrl;
  final _CategoryVisual visual;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: visual.color.withOpacity(.16),
        shape: BoxShape.circle,
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(visual.icon, color: visual.color, size: 28),
            )
          : Icon(visual.icon, color: visual.color, size: 28),
    );
  }
}

class _CategoryVisual {
  const _CategoryVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
