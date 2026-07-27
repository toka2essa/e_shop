import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
