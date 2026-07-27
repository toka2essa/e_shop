import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/domain/auth/repositories/auth_repository.dart';
import 'package:eshop_app/infrastructure/auth/data_sources/auth_remote_data_source.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  bool _parseIsSuccess(Map<String, dynamic> data) {
    if (data['isSuccess'] is bool) return data['isSuccess'];
    if (data['success'] is bool) return data['success'];
    if (data['Success'] is bool) return data['Success'];
    if (data['succeeded'] is bool) return data['succeeded'];
    if (data['status'] is bool) return data['status'];
    return true;
  }

  String _parseMessage(Map<String, dynamic> data, String fallback) {
    return data['message']?.toString() ??
        data['Message']?.toString() ??
        data['detail']?.toString() ??
        data['title']?.toString() ??
        fallback;
  }

  @override
  Future<Either<ServerFailure, String>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) => Left<ServerFailure, String>(failure),
      (data) {
        final bool isSuccess = _parseIsSuccess(data);
        final message = _parseMessage(data, 'Registration completed successfully.');
            
        if (!isSuccess) {
          return Left<ServerFailure, String>(ServerFailure(message));
        }
        return Right<ServerFailure, String>(message);
      },
    );
  }

  @override
  Future<Either<ServerFailure, String>> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) => Left<ServerFailure, String>(failure),
      (data) {
        final bool isSuccess = _parseIsSuccess(data);
        final message = _parseMessage(data, 'Login successful.');
            
        if (!isSuccess) {
          return Left<ServerFailure, String>(ServerFailure(message));
        }
        return Right<ServerFailure, String>(message);
      },
    );
  }

  @override
  Future<Either<ServerFailure, String>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final result = await remoteDataSource.verifyEmail(
      email: email,
      otp: otp,
    );

    return result.fold(
      (failure) => Left<ServerFailure, String>(failure),
      (data) {
        final bool isSuccess = _parseIsSuccess(data);
        final message = _parseMessage(
          data,
          isSuccess ? 'Email verified successfully.' : 'Invalid verification code.',
        );

        if (!isSuccess) {
          return Left<ServerFailure, String>(ServerFailure(message));
        }
        return Right<ServerFailure, String>(message);
      },
    );
  }

  @override
  Future<Either<ServerFailure, String>> resendOtp({
    required String email,
  }) async {
    final result = await remoteDataSource.resendOtp(email: email);

    return result.fold(
      (failure) => Left<ServerFailure, String>(failure),
      (data) {
        final bool isSuccess = _parseIsSuccess(data);
        final message = _parseMessage(data, 'OTP sent successfully.');
            
        if (!isSuccess) {
          return Left<ServerFailure, String>(ServerFailure(message));
        }
        return Right<ServerFailure, String>(message);
      },
    );
  }
}
