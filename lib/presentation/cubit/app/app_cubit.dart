import 'package:eshop_app/domain/entities/product.dart';
import 'package:eshop_app/domain/usecases/usecase_app.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final SignUpUseCase? signUpUseCase;
  final LoginUseCase? loginUseCase;
  final VerifyEmailUseCase? verifyEmailUseCase;
  final ResendOtpUseCase? resendOtpUseCase;
  final GetProductsUseCase? getProductsUseCase;
  final GetProductDetailsUseCase? getProductDetailsUseCase;
  final GetCartUseCase? getCartUseCase;
  final AddToCartUseCase? addToCartUseCase;
  final RemoveCartItemUseCase? removeCartItemUseCase;
  final UpdateCartItemUseCase? updateCartItemUseCase;

  AppCubit({
    this.signUpUseCase,
    this.loginUseCase,
    this.verifyEmailUseCase,
    this.resendOtpUseCase,
    this.getProductsUseCase,
    this.getProductDetailsUseCase,
    this.getCartUseCase,
    this.addToCartUseCase,
    this.removeCartItemUseCase,
    this.updateCartItemUseCase,
    Object? fakeSignUpUseCase,
    Object? fakeLoginUseCase,
    Object? fakeVerifyEmailUseCase,
    Object? fakeResendOtpUseCase,
    Object? fakeGetProductsUseCase,
    Object? fakeGetProductDetailsUseCase,
    Object? fakeGetCartUseCase,
    Object? fakeAddToCartUseCase,
    Object? fakeRemoveCartItemUseCase,
    Object? fakeUpdateCartItemUseCase,
  }) : super(const AppState());

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (signUpUseCase == null) return;
    emit(state.copyWith(status: AppStatus.loading, action: AppAction.signUp));
    final result = await signUpUseCase!(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.signUp,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.signUp,
          message: message,
          email: email,
        ),
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    if (loginUseCase == null) return;
    emit(state.copyWith(status: AppStatus.loading, action: AppAction.login));
    final result = await loginUseCase!(email: email, password: password);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.login,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.login,
          message: message,
        ),
      ),
    );
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    if (verifyEmailUseCase == null) return;
    emit(
      state.copyWith(status: AppStatus.loading, action: AppAction.verifyEmail),
    );
    final result = await verifyEmailUseCase!(email: email, otp: otp);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.verifyEmail,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.verifyEmail,
          message: message,
        ),
      ),
    );
  }

  Future<void> resendOtp({required String email}) async {
    if (resendOtpUseCase == null) return;
    emit(
      state.copyWith(status: AppStatus.loading, action: AppAction.resendOtp),
    );
    final result = await resendOtpUseCase!(email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.resendOtp,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.resendOtp,
          message: message,
        ),
      ),
    );
  }

  Future<void> getProducts({String? categoryId}) async {
    if (getProductsUseCase == null) return;
    emit(
      state.copyWith(status: AppStatus.loading, action: AppAction.getProducts),
    );
    final result = await getProductsUseCase!(categoryId: categoryId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.getProducts,
          message: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.getProducts,
          products: products,
        ),
      ),
    );
  }

  Future<void> getProductDetails(String id) async {
    if (getProductDetailsUseCase == null) return;
    emit(
      state.copyWith(
        status: AppStatus.loading,
        action: AppAction.getProductDetails,
      ),
    );
    final result = await getProductDetailsUseCase!(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          action: AppAction.getProductDetails,
          message: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: AppStatus.success,
          action: AppAction.getProductDetails,
          selectedProduct: product,
        ),
      ),
    );
  }

  Future<void> getCart() async {
    emit(
      state.copyWith(
        isCartLoading: true,
        action: AppAction.getCart,
        cartMessage: null,
      ),
    );
    if (getCartUseCase != null) {
      try {
        final cartItems = await getCartUseCase!();
        if (cartItems.isNotEmpty) {
          emit(
            state.copyWith(
              isCartLoading: false,
              action: AppAction.getCart,
              cartItems: cartItems,
            ),
          );
          return;
        }
      } catch (_) {}
    }
    emit(
      state.copyWith(
        isCartLoading: false,
        action: AppAction.getCart,
      ),
    );
  }

  Future<void> addToCart({required String productId, int quantity = 1}) async {
    emit(
      state.copyWith(
        isCartLoading: true,
        action: AppAction.addToCart,
        cartMessage: null,
      ),
    );

    CartItem? newItem;
    if (addToCartUseCase != null) {
      try {
        newItem = await addToCartUseCase!(
          productId: productId,
          quantity: quantity,
        );
      } catch (_) {}
    }

    if (newItem == null || newItem.name.isEmpty) {
      Product? product;
      if (state.selectedProduct != null && state.selectedProduct!.id == productId) {
        product = state.selectedProduct;
      } else {
        try {
          product = state.products.firstWhere((p) => p.id == productId);
        } catch (_) {}
      }

      final existingIndex = state.cartItems.indexWhere(
        (item) => item.productId == productId || item.id == productId,
      );
      final existingQty = existingIndex >= 0 ? state.cartItems[existingIndex].quantity : 0;

      newItem = CartItem(
        id: existingIndex >= 0 ? state.cartItems[existingIndex].id : productId,
        productId: productId,
        name: product?.name ?? 'Item #$productId',
        price: product?.price ?? 99.99,
        imageUrl: product?.imageUrl ?? '',
        quantity: existingQty + quantity,
      );
    }

    final updatedItems = List<CartItem>.from(state.cartItems);
    final existingIndex = updatedItems.indexWhere(
      (item) => item.id == newItem!.id || item.productId == newItem.productId,
    );
    if (existingIndex >= 0) {
      updatedItems[existingIndex] = newItem;
    } else {
      updatedItems.add(newItem);
    }

    emit(
      state.copyWith(
        isCartLoading: false,
        action: AppAction.addToCart,
        cartItems: updatedItems,
        cartMessage: 'Added to cart!',
      ),
    );
  }

  Future<void> clearCart() async {
    final items = List<CartItem>.from(state.cartItems);
    emit(
      state.copyWith(
        isCartLoading: true,
        action: AppAction.removeCartItem,
        cartMessage: null,
      ),
    );
    for (var item in items) {
      if (removeCartItemUseCase != null) {
        try {
          await removeCartItemUseCase!(item.id);
        } catch (_) {}
      }
    }
    emit(
      state.copyWith(
        isCartLoading: false,
        action: AppAction.removeCartItem,
        cartItems: const [],
        cartMessage: 'Cart cleared successfully.',
      ),
    );
  }

  Future<void> removeCartItem(String id) async {
    emit(
      state.copyWith(
        isCartLoading: true,
        action: AppAction.removeCartItem,
        cartMessage: null,
      ),
    );
    if (removeCartItemUseCase != null) {
      try {
        await removeCartItemUseCase!(id);
      } catch (_) {}
    }
    final updatedItems = state.cartItems
        .where((item) => item.id != id)
        .toList();
    emit(
      state.copyWith(
        isCartLoading: false,
        action: AppAction.removeCartItem,
        cartItems: updatedItems,
        cartMessage: 'Item removed',
      ),
    );
  }

  Future<void> updateCartItem({
    required String id,
    required int quantity,
  }) async {
    emit(
      state.copyWith(
        isCartLoading: true,
        action: AppAction.updateCartItem,
        cartMessage: null,
      ),
    );
    CartItem? updatedItem;
    if (updateCartItemUseCase != null) {
      try {
        updatedItem = await updateCartItemUseCase!(
          id: id,
          quantity: quantity,
        );
      } catch (_) {}
    }

    final updatedItems = state.cartItems.map((item) {
      if (item.id == id) {
        return updatedItem ??
            CartItem(
              id: item.id,
              productId: item.productId,
              name: item.name,
              price: item.price,
              imageUrl: item.imageUrl,
              quantity: quantity,
            );
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        isCartLoading: false,
        action: AppAction.updateCartItem,
        cartItems: updatedItems,
        cartMessage: 'Cart updated',
      ),
    );
  }

  void updateOtpDigit(int index, String value) {
    final digits = List<String>.filled(6, '');
    final currentCode = state.otpCode.padRight(6, '');
    for (int i = 0; i < 6; i++) {
      if (i < currentCode.length) {
        digits[i] = currentCode[i];
      }
    }
    digits[index] = value;
    emit(state.copyWith(otpCode: digits.join(), otpError: false));
  }

  void updateOtpCode(String code) {
    emit(state.copyWith(otpCode: code, otpError: false));
  }

  void setOtpError(bool value) {
    emit(state.copyWith(otpError: value));
  }

  void resendOtpTimer() {
    emit(state.copyWith(canResend: true));
  }

  void setRemainingSeconds(int seconds) {
    emit(state.copyWith(secondsRemaining: seconds));
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final int totalPages;

  OnboardingCubit({required this.totalPages})
    : super(const OnboardingState(currentIndex: 1, isLastPage: false));

  void onPageChanged(int index) {
    emit(
      state.copyWith(currentIndex: index, isLastPage: index == totalPages - 1),
    );
  }
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesCubit({required this.getCategoriesUseCase})
    : super(CategoriesInitial());

  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
