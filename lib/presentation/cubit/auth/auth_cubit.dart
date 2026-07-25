import 'package:eshop_app/domain/auth/usecases/resend_otp_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/verify_email_use_case.dart';
import 'package:eshop_app/domain/auth/usecases/sign_up_use_case.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AuthCubit(
    this.signUpUseCase,
    this.verifyEmailUseCase,
    this.resendOtpUseCase,
  ) : super(const AuthInitial());

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await signUpUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    if (!isClosed) {
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (message) => emit(AuthSuccess(message)),
      );
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    emit(const AuthLoading());
    final result = await verifyEmailUseCase(email: email, otp: otp);
    if (!isClosed) {
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (message) => emit(EmailVerified(message)),
      );
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(const AuthLoading());
    final result = await resendOtpUseCase(email: email);
    if (!isClosed) {
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (message) => emit(OtpResent(message)),
      );
    }
  }
}
