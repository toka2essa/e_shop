import 'package:eshop_app/domain/entities/product.dart';
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

  Future<Either<ServerFailure, String>> resendOtp({required String email});
}

abstract class ProductRepository {
  Future<Either<ServerFailure, List<Product>>> getProducts();
  Future<Either<ServerFailure, Product>> getProductById(String id);
}

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
}

abstract class CategorydetailsRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity> getCategoryById(String id);
}
