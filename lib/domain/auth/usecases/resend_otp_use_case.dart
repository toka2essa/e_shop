import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Either<Failure, String>> call({required String email}) async {
    return await repository.resendOtp(email: email);
  }
}