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

  AppCubit({
    this.signUpUseCase,
    this.loginUseCase,
    this.verifyEmailUseCase,
    this.resendOtpUseCase,
    this.getProductsUseCase,
    this.getProductDetailsUseCase,
    Object? fakeSignUpUseCase,
    Object? fakeLoginUseCase,
    Object? fakeVerifyEmailUseCase,
    Object? fakeResendOtpUseCase,
    Object? fakeGetProductsUseCase,
    Object? fakeGetProductDetailsUseCase,
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

  Future<void> getProducts() async {
    if (getProductsUseCase == null) return;
    emit(
      state.copyWith(status: AppStatus.loading, action: AppAction.getProducts),
    );
    final result = await getProductsUseCase!();
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
