import 'package:eshop_app/core/network/rest/api/api_consumer.dart';
import 'package:eshop_app/core/network/rest/api/end_points.dart';
import 'package:eshop_app/core/network/rest/auth_token_storage.dart';
import 'package:eshop_app/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';
import 'package:eshop_app/core/network/rest/errors/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      body: {'email': email, 'password': password},
    );
  }

  Future<Either<ServerFailure, Map<String, dynamic>>> verifyEmail({
    required String email,
    required String otp,
  }) {
    return apiConsumer.post(
      path: EndPoints.verifyEmail,
      body: {'email': email, 'otp': otp},
    );
  }

  Future<Either<ServerFailure, Map<String, dynamic>>> resendOtp({
    required String email,
  }) {
    return apiConsumer.post(path: EndPoints.resendOtp, body: {'email': email});
  }
}

class OnboardingModel extends OnboardingEntity {
  const OnboardingModel({
    required super.title,
    required super.description,
    required super.imagePath,
  });

  static List<OnboardingModel> get onboardingPages => const [
    OnboardingModel(
      title: 'Welcome',
      description:
          'Discover thousands of top brands in one seamless app experience.',
      imagePath: 'assets/onboardingOne.png',
    ),
    OnboardingModel(
      title: 'Connect',
      description: 'Stay Connected With Your Favorite Brands Easily.',
      imagePath: 'assets/two.png',
    ),
    OnboardingModel(
      title: 'Explore',
      description:
          'Get exclusive offers and customized deals tailored just for you.',
      imagePath: 'assets/three.png',
    ),
  ];
}

class ProductRemoteDataSource {
  final ApiConsumer _api;
  final AuthTokenStorage _tokenStorage;

  ProductRemoteDataSource(this._api, this._tokenStorage);

  Future<Either<ServerFailure, List<Product>>> getProducts({
    String? categoryId,
  }) async {
    final token = await _tokenStorage.read();
    final result = await _api.get(
      path: EndPoints.products,
      queryParameters: categoryId != null ? {'categoryId': categoryId} : null,
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.map((data) {
      final itemsList = _extractProductItems(data);

      return itemsList
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    });
  }

  List<dynamic> _extractProductItems(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return const [];

    final data = Map<String, dynamic>.from(value);
    for (final key in const ['items', 'products', 'data', 'result']) {
      final items = _extractProductItems(data[key]);
      if (items.isNotEmpty) return items;
    }
    return const [];
  }

  Future<Either<ServerFailure, Product>> getProductById(String id) async {
    final token = await _tokenStorage.read();
    final result = await _api.get(
      path: EndPoints.productDetails(id),
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.map((data) {
      final Map<String, dynamic> item = data['data'] ?? data;
      return Product.fromJson(item);
    });
  }
}

abstract class CartRemoteDataSource {
  Future<List<CartItem>> getCartItems();
  Future<CartItem> addToCart({
    required String productId,
    required int quantity,
  });
  Future<void> removeCartItem(String id);
  Future<CartItem> updateCartItem({required String id, required int quantity});
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiConsumer _api;
  final AuthTokenStorage _tokenStorage;

  CartRemoteDataSourceImpl(this._api, this._tokenStorage);

  @override
  Future<List<CartItem>> getCartItems() async {
    final token = await _tokenStorage.read();
    final result = await _api.get(
      path: EndPoints.cart,
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.fold((failure) => throw Exception(failure.message), (data) {
      final itemsList = _extractCartItems(data);
      return itemsList
          .whereType<Map>()
          .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    });
  }

  List<dynamic> _extractCartItems(dynamic value) {
    if (value is List) return value;
    if (value is! Map) return const [];

    final data = Map<String, dynamic>.from(value);
    for (final key in const [
      'items',
      'cart',
      'cartItems',
      'cart_items',
      'data',
      'result',
    ]) {
      final items = _extractCartItems(data[key]);
      if (items.isNotEmpty) return items;
    }
    return const [];
  }

  Map<String, dynamic> _extractCartItem(dynamic value) {
    if (value is Map) {
      final data = Map<String, dynamic>.from(value);
      if (_looksLikeCartItem(data)) return data;

      for (final entry in data.entries) {
        final extracted = _extractCartItem(entry.value);
        if (extracted.isNotEmpty) return extracted;
      }
      return const {};
    }

    if (value is List) {
      for (final item in value) {
        final extracted = _extractCartItem(item);
        if (extracted.isNotEmpty) return extracted;
      }
      return const {};
    }

    return const {};
  }

  bool _looksLikeCartItem(Map<String, dynamic> value) {
    return value.keys.toSet().intersection({
      'id',
      'cartItemId',
      'itemId',
      'productId',
      'product',
      'quantity',
    }).isNotEmpty;
  }

  @override
  Future<CartItem> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final token = await _tokenStorage.read();
    final result = await _api.post(
      path: EndPoints.cartItems,
      body: {'productId': productId, 'quantity': quantity},
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.fold((failure) => throw Exception(failure.message), (data) {
      final itemData = _extractCartItem(data);
      return CartItem.fromJson(
        itemData.isNotEmpty
            ? itemData
            : Map<String, dynamic>.from(data['data'] ?? data),
      );
    });
  }

  @override
  Future<void> removeCartItem(String id) async {
    final token = await _tokenStorage.read();
    final result = await _api.delete(
      path: EndPoints.cartItemDetails(id),
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }

  @override
  Future<CartItem> updateCartItem({
    required String id,
    required int quantity,
  }) async {
    final token = await _tokenStorage.read();
    final result = await _api.put(
      path: EndPoints.cartItemDetails(id),
      body: {'quantity': quantity},
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );
    return result.fold((failure) => throw Exception(failure.message), (data) {
      final itemData = _extractCartItem(data);
      return CartItem.fromJson(
        itemData.isNotEmpty
            ? itemData
            : Map<String, dynamic>.from(data['data'] ?? data),
      );
    });
  }
}

abstract class SplashLocalDataSource {
  Future<bool> isFirstTime();
  Future<void> setFirstTimeCompleted();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl({required this.sharedPreferences});

  static const String _firstTimeKey = 'is_first_time';

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool(_firstTimeKey) ?? true;
  }

  @override
  Future<void> setFirstTimeCompleted() async {
    await sharedPreferences.setBool(_firstTimeKey, false);
  }
}

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiConsumer _api;
  final AuthTokenStorage _tokenStorage;

  CategoryRemoteDataSourceImpl(this._api, this._tokenStorage);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final token = await _tokenStorage.read();

    final result = await _api.get(
      path: EndPoints.categories,
      headers: token == null || token.isEmpty
          ? null
          : {'Authorization': 'Bearer $token'},
    );

    return result.fold((failure) => throw Exception(failure.message), (data) {
      final rawCategories =
          data['items'] ?? data['data'] ?? data['categories'] ?? data;

      if (rawCategories is! List) {
        throw Exception('Invalid categories response');
      }

      return rawCategories
          .whereType<Map>()
          .map<CategoryModel>(
            (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    });
  }
}
