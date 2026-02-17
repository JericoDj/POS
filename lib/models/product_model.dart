class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int stock;
  final String? imageUrl;
  final String details;
  final DateTime? createdAt;
  final String? businessId;

  // Helper for UI to show category name (will need to be joined with categories)
  String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.details,
    this.createdAt,
    this.categoryName,
    this.businessId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      String parsedCategoryId = '';
      String? parsedCategoryName;

      if (json['categoryId'] is String) {
        parsedCategoryId = json['categoryId'];
      } else if (json['categoryId'] is Map) {
        final catMap = json['categoryId'];
        parsedCategoryId = catMap['id'] ?? catMap['_id'] ?? '';
        parsedCategoryName = catMap['name'];
      }

      // Safe parsing for other fields
      String parsedId = json['id'] ?? json['_id'] ?? '';
      String parsedName = json['name'] as String? ?? '';
      // Handle case where name might be numeric or something else
      if (json['name'] is! String && json['name'] != null) {
        parsedName = json['name'].toString();
      }

      String parsedDetails = json['details'] as String? ?? '';
      if (json['details'] is! String && json['details'] != null) {
        parsedDetails = json['details'].toString();
      }

      String? parsedImageUrl = json['imageUrl'] as String?;
      if (json['imageUrl'] is! String && json['imageUrl'] != null) {
        // If it's a map (unlikely for image), just ignore or toString
        parsedImageUrl = null;
      }

      DateTime? parsedCreatedAt;
      if (json['createdAt'] is String) {
        parsedCreatedAt = DateTime.tryParse(json['createdAt']);
      }

      String? parsedBusinessId = json['businessId'] as String?;

      return Product(
        id: parsedId,
        name: parsedName,
        categoryId: parsedCategoryId,
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        imageUrl: parsedImageUrl,
        details: parsedDetails,
        createdAt: parsedCreatedAt,
        categoryName: parsedCategoryName,
        businessId: parsedBusinessId,
      );
    } catch (e) {
      print('Error parsing Product: $json');
      print('Error details: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'details': details,
      'createdAt': createdAt?.toIso8601String(),
      'businessId': businessId,
    };
  }
}
