import 'package:eshop_app/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/domain/repositories/app_repository.dart';
import 'package:eshop_app/infrastructure/data_sources/app_dataSource.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/core/network/rest/auth_token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthTokenStorage _tokenStorage;

  AuthRepositoryImpl(this.remoteDataSource, this._tokenStorage);

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

    return result.fold((failure) => Left<ServerFailure, String>(failure), (
      data,
    ) {
      final bool isSuccess = _parseIsSuccess(data);
      final message = _parseMessage(
        data,
        'Registration completed successfully.',
      );

      if (!isSuccess) {
        return Left<ServerFailure, String>(ServerFailure(message));
      }
      return Right<ServerFailure, String>(message);
    });
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

    return result.fold((failure) => Left<ServerFailure, String>(failure), (
      data,
    ) async {
      final bool isSuccess = _parseIsSuccess(data);
      final message = _parseMessage(data, 'Login successful.');

      if (!isSuccess) {
        return Left<ServerFailure, String>(ServerFailure(message));
      }

      final token = _extractToken(data);
      if (token == null) {
        return Left<ServerFailure, String>(
          ServerFailure('Login succeeded but no access token was returned.'),
        );
      }
      await _tokenStorage.save(token);
      return Right<ServerFailure, String>(message);
    });
  }

  String? _extractToken(Map<String, dynamic> data) {
    final directToken =
        data['token'] ??
        data['Token'] ??
        data['accessToken'] ??
        data['access_token'] ??
        data['jwt'];
    if (directToken is String && directToken.isNotEmpty) return directToken;

    final nestedData = data['data'] ?? data['result'];
    if (nestedData is Map) {
      return _extractToken(Map<String, dynamic>.from(nestedData));
    }
    return null;
  }

  @override
  Future<Either<ServerFailure, String>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final result = await remoteDataSource.verifyEmail(email: email, otp: otp);

    return result.fold((failure) => Left<ServerFailure, String>(failure), (
      data,
    ) {
      final bool isSuccess = _parseIsSuccess(data);
      final message = _parseMessage(
        data,
        isSuccess
            ? 'Email verified successfully.'
            : 'Invalid verification code.',
      );

      if (!isSuccess) {
        return Left<ServerFailure, String>(ServerFailure(message));
      }
      return Right<ServerFailure, String>(message);
    });
  }

  @override
  Future<Either<ServerFailure, String>> resendOtp({
    required String email,
  }) async {
    final result = await remoteDataSource.resendOtp(email: email);

    return result.fold((failure) => Left<ServerFailure, String>(failure), (
      data,
    ) {
      final bool isSuccess = _parseIsSuccess(data);
      final message = _parseMessage(data, 'OTP sent successfully.');

      if (!isSuccess) {
        return Left<ServerFailure, String>(ServerFailure(message));
      }
      return Right<ServerFailure, String>(message);
    });
  }
}

abstract class SplashRepository {
  Future<bool> checkIsFirstTime();
  Future<void> saveFirstTimeCompleted();
}

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> checkIsFirstTime() {
    return localDataSource.isFirstTime();
  }

  @override
  Future<void> saveFirstTimeCompleted() {
    return localDataSource.setFirstTimeCompleted();
  }
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ServerFailure, List<Product>>> getProducts({
    String? categoryId,
  }) {
    return _remoteDataSource.getProducts(categoryId: categoryId);
  }

  @override
  Future<Either<ServerFailure, Product>> getProductById(String id) {
    return _remoteDataSource.getProductById(id);
  }
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryModel>> getCategories() {
    return remoteDataSource.getCategories();
  }
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CartItem>> getCartItems() {
    return remoteDataSource.getCartItems();
  }

  @override
  Future<CartItem> addToCart({
    required String productId,
    required int quantity,
  }) {
    return remoteDataSource.addToCart(productId: productId, quantity: quantity);
  }

  @override
  Future<void> removeCartItem(String id) {
    return remoteDataSource.removeCartItem(id);
  }

  @override
  Future<CartItem> updateCartItem({required String id, required int quantity}) {
    return remoteDataSource.updateCartItem(id: id, quantity: quantity);
  }
}
