import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/core/network/rest/api/end_points.dart';
import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';

class AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSource(this.apiConsumer);

  Future<Either<ServerFailure, Map<String, dynamic>>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return apiConsumer.post(
      path: EndPoints.register,
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Either<ServerFailure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) {
    return apiConsumer.post(
      path: EndPoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Either<ServerFailure, Map<String, dynamic>>> verifyEmail({
    required String email,
    required String otp,
  }) {
    return apiConsumer.post(
      path: EndPoints.verifyEmail,
      body: {
        'email': email,
        'otp': otp,
      },
    );}
Future<Either<ServerFailure, Map<String, dynamic>>> resendOtp({
  required String email,
}) {
  return apiConsumer.post(
    path: EndPoints.resendOtp,
    body: {'email': email},
  );
}}