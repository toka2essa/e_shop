import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/entities/product.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<ServerFailure, List<Product>>> getProducts();
  Future<Either<ServerFailure, Product>> getProductById(String id);
}
