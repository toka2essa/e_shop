class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          json['title']?.toString() ??
          json['arabicName']?.toString() ??
          '',
      description:
          json['description']?.toString() ??
          json['arabicDescription']?.toString() ??
          '',
      price: _parsePrice(json['price']),
      imageUrl:
          json['coverPictureUrl']?.toString() ??
          json['imageUrl']?.toString() ??
          json['pictureUrl']?.toString() ??
          json['image']?.toString() ??
          '',
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class OnboardingEntity {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingEntity({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class CategoryEntity {
  final int id;
  final String name;
  final String? imageUrl;

  const CategoryEntity({required this.id, required this.name, this.imageUrl});
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name, super.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _parseId(json['id'] ?? json['categoryId']),
      name:
          json['name']?.toString() ??
          json['categoryName']?.toString() ??
          json['arabicName']?.toString() ??
          '',
      imageUrl:
          json['imageUrl']?.toString() ??
          json['imagePath']?.toString() ??
          json['image']?.toString() ??
          json['pictureUrl']?.toString(),
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageUrl': imageUrl};
  }
}

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final itemData = Map<String, dynamic>.from(json);
    final productData = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : <String, dynamic>{};

    final rawId =
        itemData['id']?.toString() ??
        itemData['cartItemId']?.toString() ??
        itemData['itemId']?.toString();

    return CartItem(
      id: rawId ?? '',
      productId:
          itemData['productId']?.toString() ??
          itemData['productID']?.toString() ??
          itemData['product_id']?.toString() ??
          productData['id']?.toString() ??
          productData['productId']?.toString() ??
          '',
      name:
          itemData['name']?.toString() ??
          itemData['title']?.toString() ??
          itemData['productName']?.toString() ??
          productData['name']?.toString() ??
          productData['title']?.toString() ??
          itemData['nameAr']?.toString() ??
          '',
      price: Product._parsePrice(
        itemData['price'] ??
            itemData['unitPrice'] ??
            productData['price'] ??
            productData['unitPrice'],
      ),
      imageUrl:
          itemData['imageUrl']?.toString() ??
          itemData['pictureUrl']?.toString() ??
          itemData['image']?.toString() ??
          itemData['imageUrl']?.toString() ??
          itemData['picture_url']?.toString() ??
          productData['imageUrl']?.toString() ??
          productData['pictureUrl']?.toString() ??
          productData['image']?.toString() ??
          productData['image_url']?.toString() ??
          '',
      quantity:
          int.tryParse(itemData['quantity']?.toString() ?? '') ??
          int.tryParse(itemData['qty']?.toString() ?? '') ??
          int.tryParse(itemData['count']?.toString() ?? '') ??
          int.tryParse(productData['quantity']?.toString() ?? '') ??
          1,
    );
  }
}
