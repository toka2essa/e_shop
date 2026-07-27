import 'package:eshop_app/domain/entities/product.dart';

enum AppStatus { initial, loading, success, failure }

enum AppAction {
  initial,
  signUp,
  login,
  verifyEmail,
  resendOtp,
  getProducts,
  getProductDetails,
}

class AppState {
  final AppStatus status;
  final AppAction action;
  final String? message;
  final List<Product> products;
  final Product? selectedProduct;
  final String otpCode;
  final bool otpError;
  final bool canResend;
  final int secondsRemaining;
  final String? email;

  const AppState({
    this.status = AppStatus.initial,
    this.action = AppAction.initial,
    this.message,
    this.products = const [],
    this.selectedProduct,
    this.otpCode = '',
    this.otpError = false,
    this.canResend = false,
    this.secondsRemaining = 60,
    this.email,
  });

  bool get isLoading => status == AppStatus.loading;

  AppState copyWith({
    AppStatus? status,
    AppAction? action,
    String? message,
    List<Product>? products,
    Product? selectedProduct,
    String? otpCode,
    bool? otpError,
    bool? canResend,
    int? secondsRemaining,
    String? email,
  }) {
    return AppState(
      status: status ?? this.status,
      action: action ?? this.action,
      message: message,
      products: products ?? this.products,
      selectedProduct: selectedProduct,
      otpCode: otpCode ?? this.otpCode,
      otpError: otpError ?? this.otpError,
      canResend: canResend ?? this.canResend,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      email: email ?? this.email,
    );
  }
}

class OnboardingState {
  final int currentIndex;
  final bool isLastPage;

  const OnboardingState({required this.currentIndex, required this.isLastPage});

  OnboardingState copyWith({int? currentIndex, bool? isLastPage}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryEntity> categories;
  CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}
