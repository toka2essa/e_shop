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
      name: json['name']?.toString() ?? json['title']?.toString() ?? json['arabicName']?.toString() ?? '',
      description: json['description']?.toString() ?? json['arabicDescription']?.toString() ?? '',
      price: _parsePrice(json['price']),
      imageUrl: json['coverPictureUrl']?.toString() ??
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
