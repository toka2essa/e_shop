import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}
