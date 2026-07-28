import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  static const _categoryVisuals = [
    _CategoryVisual(
      icon: Icons.watch_rounded,
      colors: [Color(0xFFFF6B00), Color(0xFFFF9E00)],
      subtitle: 'Smartwatches & Timepieces',
      keywords: ['ساعة', 'watch', 'smartwatch'],
    ),
    _CategoryVisual(
      icon: Icons.headphones_rounded,
      colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
      subtitle: 'Audio & Wireless Sound',
      keywords: ['سماعة', 'headphone', 'headset', 'audio'],
    ),
    _CategoryVisual(
      icon: Icons.shopping_bag_rounded,
      colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
      subtitle: 'Bags & Luxury Leather',
      keywords: ['شنطة', 'حقيبة', 'bag', 'shopping'],
    ),
    _CategoryVisual(
      icon: Icons.diamond_rounded,
      colors: [Color(0xFF10B981), Color(0xFF34D399)],
      subtitle: 'Fine Jewelry & Gems',
      keywords: ['مجوهرات', 'diamond', 'jewelry', 'ring'],
    ),
    _CategoryVisual(
      icon: Icons.account_balance_wallet_rounded,
      colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      subtitle: 'Wallets & Cardholders',
      keywords: ['محفظة', 'wallet', 'cardholder'],
    ),
    _CategoryVisual(
      icon: Icons.checkroom_rounded,
      colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      subtitle: 'Apparel & Modern Fashion',
      keywords: ['ملابس', 'clothes', 'fashion', 'apparel'],
    ),
    _CategoryVisual(
      icon: Icons.auto_awesome_rounded,
      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
      subtitle: 'Exclusive Accessories',
      keywords: ['إكسسوارات', 'accessory', 'exclusive'],
    ),
  ];

  static _CategoryVisual _getVisualByName(String name) {
    final lower = name.toLowerCase();
    return _categoryVisuals.firstWhere(
      (visual) => visual.keywords.any(lower.contains),
      orElse: () => const _CategoryVisual(
        icon: Icons.grid_view_rounded,
        colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
        subtitle: 'Explore Products',
        keywords: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.category_rounded,
                  color: AppColors.primaryOrange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Categories',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push(AppRoutes.product),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primaryOrange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 185,
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
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final visual = _getVisualByName(category.name);

                    return Container(
                      width: 130,
                      margin: const EdgeInsets.only(right: 14),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => context.push(
                            AppRoutes.product,
                            extra: category,
                          ),
                          child: Ink(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF262626),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
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
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  visual.subtitle,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
        const SizedBox(height: 16),
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
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryOrange.withValues(alpha: 0.4),
            ),
            color: AppColors.primaryOrange.withValues(alpha: 0.1),
          ),
          child: const Row(
            children: [
              Icon(Icons.grid_view_rounded, color: AppColors.primaryOrange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Explore All Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primaryOrange,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryThumbnail extends StatelessWidget {
  const _CategoryThumbnail({
    required this.imageUrl,
    required this.visual,
  });

  final String? imageUrl;
  final _CategoryVisual visual;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: visual.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: visual.colors.first.withValues(alpha: 0.45),
            blurRadius: 16,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    visual.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            : Center(
                child: Icon(
                  visual.icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
      ),
    );
  }
}

class _CategoryVisual {
  const _CategoryVisual({
    required this.icon,
    required this.colors,
    required this.subtitle,
    this.keywords = const [],
  });

  final IconData icon;
  final List<Color> colors;
  final String subtitle;
  final List<String> keywords;
}
