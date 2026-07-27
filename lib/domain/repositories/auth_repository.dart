import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<ServerFailure, String>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<ServerFailure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<ServerFailure, String>> verifyEmail({
    required String email,
    required String otp,
  });

  Future<Either<ServerFailure, String>> resendOtp({
    required String email,
  });

}
