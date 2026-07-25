import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/core/network/rest/api/end_points.dart';

class Api implements ApiConsumer {
  final Dio _dio;

  Api()
      : _dio = Dio(
          BaseOptions(
            baseUrl: EndPoints.baseUrl,
          ),
        );

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return Right(_toMap(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(_errorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> post({
    required String path,
    required Object body,
    String? contentType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
          contentType: contentType ?? 'application/json',
        ),
      );

      return Right(_toMap(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(_errorMessage(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> put({
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return Right(_toMap(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(_errorMessage(e)));
    }
  }

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return Right(_toMap(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(_errorMessage(e)));
    }
  }

  Map<String, dynamic> _toMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return {};
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return {'data': decoded};
      } catch (_) {
        return {'data': trimmed};
      }
    }
    return {'data': data};
  }

  String _errorMessage(DioException error) {
    final data = error.response?.data;

    if (data != null) {
      if (data is Map) {
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            final messages = <String>[];
            errors.forEach((key, val) {
              if (val is List) {
                messages.addAll(val.map((e) => e.toString()));
              } else if (val != null) {
                messages.add(val.toString());
              }
            });
            if (messages.isNotEmpty) return messages.join('\n');
          } else if (errors is List && errors.isNotEmpty) {
            return errors.join('\n');
          }
        }
        if (data['message'] != null) return data['message'].toString();
        if (data['Message'] != null) return data['Message'].toString();
        if (data['detail'] != null) return data['detail'].toString();
        if (data['title'] != null) return data['title'].toString();
      } else if (data is String && data.isNotEmpty) {
        return data;
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check internet access.';
    }

    return error.message ?? 'Something went wrong. Please try again.';
  }
}
