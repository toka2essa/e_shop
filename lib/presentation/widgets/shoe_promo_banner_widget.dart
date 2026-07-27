import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ShoePromoBannerWidget extends StatefulWidget {
  const ShoePromoBannerWidget({super.key});

  @override
  State<ShoePromoBannerWidget> createState() => _ShoePromoBannerWidgetState();
}

class _ShoePromoBannerWidgetState extends State<ShoePromoBannerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static const _shoeImageUrl =
      'https://images.unsplash.com/photo-1698108223397-3d222e80d7ea?auto=format&fit=crop&fm=jpg&ixlib=rb-4.1.0&q=80&w=1200';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: 0,
            bottom: 0,
            width: MediaQuery.sizeOf(context).width * .56,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final progress = Curves.easeInOut.transform(
                  _animationController.value,
                );
                return Transform.translate(
                  offset: Offset(-8 * progress, 0),
                  child: Transform.scale(
                    scale: 1 + (.06 * progress),
                    child: child,
                  ),
                );
              },
              child: Image.network(
                _shoeImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.directions_run,
                    color: AppColors.textSecondary,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2A2A2A),
                    const Color(0xFF2A2A2A).withOpacity(.9),
                    const Color(0xFF2A2A2A).withOpacity(.08),
                  ],
                  stops: const [0, .45, 1],
                ),
              ),
            ),
          ),
          const Positioned(
            left: 20,
            top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New arrivals',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Step into style',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Shoes for every day',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
