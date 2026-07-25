import 'package:eshop_app/domain/auth/usecases/login_use_case.dart';
import 'package:eshop_app/presentation/cubit/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (message) => emit(LoginSuccess(message)),
    );
  }
}
