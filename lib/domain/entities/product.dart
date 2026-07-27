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
      name: json['name']?.toString() ??
          json['categoryName']?.toString() ??
          json['arabicName']?.toString() ??
          '',
      imageUrl: json['imageUrl']?.toString() ??
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
