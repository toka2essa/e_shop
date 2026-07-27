import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/core/network/rest/api/end_points.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:eshop_app/domain/auth/entities/product.dart';
import 'package:fpdart/fpdart.dart';

class ProductRemoteDataSource {
  final ApiConsumer _api;

  ProductRemoteDataSource(this._api);

  Future<Either<ServerFailure, List<Product>>> getProducts() async {
    final result = await _api.get(path: EndPoints.products);
    return result.map((data) {
      final dynamic rawItems = data['items'] ?? data['data'] ?? data['products'];
      final List<dynamic> itemsList = rawItems is List ? rawItems as List : [];

      return itemsList
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    });
  }

  Future<Either<ServerFailure, Product>> getProductById(String id) async {
    final result = await _api.get(path: EndPoints.productDetails(id));
    return result.map((data) {
      final Map<String, dynamic> item = data['data'] ?? data;
      return Product.fromJson(item);
    });
  }
}
