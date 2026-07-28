import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:eshop_app/presentation/widgets/cart_item_card_widget.dart';
import 'package:eshop_app/presentation/widgets/checkout_bottom_sheet_widget.dart';
import 'package:eshop_app/presentation/widgets/empty_cart_view_widget.dart';
import 'package:eshop_app/presentation/widgets/free_shipping_bar_widget.dart';
import 'package:eshop_app/presentation/widgets/order_summary_card_widget.dart';
import 'package:eshop_app/presentation/widgets/promo_code_card_widget.dart';
import 'package:eshop_app/presentation/widgets/sticky_checkout_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  double _discountRate = 0.0;
  double _fixedDiscount = 0.0;
  static const double _freeShippingThreshold = 500.0;
  static const double _baseDeliveryFee = 45.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppCubit>().getCart();
      }
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    FocusScope.of(context).unfocus();

    if (code == 'ESHOP10' || code == 'SAVE10') {
      setState(() {
        _appliedCoupon = code;
        _discountRate = 0.10;
        _fixedDiscount = 0.0;
      });
      _showSnackBar('Coupon applied! 10% discount added.', isError: false);
    } else if (code == 'OFF50' || code == 'SAVE50') {
      setState(() {
        _appliedCoupon = code;
        _discountRate = 0.0;
        _fixedDiscount = 50.0;
      });
      _showSnackBar('Coupon applied! 50 EGP discount added.', isError: false);
    } else {
      _showSnackBar('Invalid or expired coupon code.', isError: true);
    }
  }

  void _removeCoupon() {
    setState(() {
      _appliedCoupon = null;
      _discountRate = 0.0;
      _fixedDiscount = 0.0;
      _couponController.clear();
    });
    _showSnackBar('Coupon removed.', isError: false);
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              'Clear Shopping Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<AppCubit>().clearCart();
              _showSnackBar('Cart cleared successfully.');
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final itemCount = state.cartItems.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );

        final double subtotal = state.cartItems.fold(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );

        final bool isFreeShipping = subtotal >= _freeShippingThreshold;
        final double deliveryFee = isFreeShipping ? 0.0 : _baseDeliveryFee;
        final double discountAmount =
            (_discountRate * subtotal) + _fixedDiscount;
        final double finalTotal = (subtotal + deliveryFee - discountAmount)
            .clamp(0.0, double.infinity);

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (itemCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$itemCount ${itemCount == 1 ? "item" : "items"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (state.cartItems.isNotEmpty)
                IconButton(
                  tooltip: 'Clear Cart',
                  onPressed: _confirmClearCart,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
              const SizedBox(width: 4),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state.isCartLoading && state.cartItems.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryOrange),
                );
              }

              if (state.cartItems.isEmpty) {
                return const EmptyCartViewWidget();
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Free Shipping Tracker Bar
                    FreeShippingBarWidget(
                      subtotal: subtotal,
                      threshold: _freeShippingThreshold,
                    ),
                    const SizedBox(height: 14),

                    // Cart Items List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.cartItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = state.cartItems[index];
                        return CartItemCardWidget(
                          item: item,
                          onRemove: () {
                            context.read<AppCubit>().removeCartItem(item.id);
                            _showSnackBar('Removed ${item.name} from cart.');
                          },
                          onUpdateQuantity: (newQuantity) {
                            context.read<AppCubit>().updateCartItem(
                                  id: item.id,
                                  quantity: newQuantity,
                                );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    // Promo Code Card
                    PromoCodeCardWidget(
                      controller: _couponController,
                      appliedCoupon: _appliedCoupon,
                      onApply: _applyCoupon,
                      onRemove: _removeCoupon,
                    ),
                    const SizedBox(height: 14),

                    // Order Summary Card
                    OrderSummaryCardWidget(
                      subtotal: subtotal,
                      deliveryFee: deliveryFee,
                      discountAmount: discountAmount,
                      finalTotal: finalTotal,
                      isFreeShipping: isFreeShipping,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: state.cartItems.isNotEmpty
              ? StickyCheckoutBarWidget(
                  finalTotal: finalTotal,
                  onCheckout: () {
                    CheckoutBottomSheetWidget.show(
                      context,
                      finalTotal: finalTotal,
                      onConfirm: () {
                        _showSnackBar('Order placed successfully! Thank you 🎉');
                      },
                    );
                  },
                )
              : null,
        );
      },
    );
  }
}
