import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/entities/product.dart';
import 'package:eshop_app/domain/auth/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<ServerFailure, Product>> call(String id) {
    return repository.getProductById(id);
  }
}
