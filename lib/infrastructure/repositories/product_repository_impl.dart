import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/entities/product.dart';
import 'package:eshop_app/infrastructure/auth/data_sources/product_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/auth/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ServerFailure, List<Product>>> getProducts() {
    return _remoteDataSource.getProducts();
  }

  @override
  Future<Either<ServerFailure, Product>> getProductById(String id) {
    return _remoteDataSource.getProductById(id);
  }
}
