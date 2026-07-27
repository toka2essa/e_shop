import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/repositories/app_repository.dart';
import 'package:eshop_app/domain/usecases/login_use_case.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('AppCubit', () {
    test('starts with initial state', () {
      final cubit = AppCubit();

      expect(cubit.state.status, AppStatus.initial);
      cubit.close();
    });

    test('emits login action when login succeeds', () async {
      final cubit = AppCubit(loginUseCase: LoginUseCase(_FakeAuthRepository()));

      await cubit.login(email: 'test@example.com', password: '123456');

      expect(cubit.state.status, AppStatus.success);
      expect(cubit.state.action, AppAction.login);
      expect(cubit.state.message, 'Logged in successfully');
      cubit.close();
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<ServerFailure, String>> login({
    required String email,
    required String password,
  }) async {
    return const Right('Logged in successfully');
  }

  @override
  Future<Either<ServerFailure, String>> resendOtp({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, String>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, String>> verifyEmail({
    required String email,
    required String otp,
  }) {
    throw UnimplementedError();
  }
}
