import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/entities/product.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<Either<ServerFailure, List<Product>>> call() {
    return _repository.getProducts();
  }
}
