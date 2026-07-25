import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<ServerFailure, String>> call({
    required String email,
    required String otp,
  }) {
    return repository.verifyEmail(email: email, otp: otp);
  }
}
