class SaleItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Sale {
  final String? id;
  final List<SaleItem> items;
  final double totalAmount;
  final String paymentMethod;
  final String? businessId;
  final String? status;
  final DateTime? createdAt;

  Sale({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.businessId,
    this.status,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      if (businessId != null) 'businessId': businessId,
      if (status != null) 'status': status,
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? json['_id'],
      items: (json['items'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'],
      businessId: json['businessId'],
      status: json['status'],
      createdAt: json['createdAt'] == null
          ? null
          : json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : json['createdAt'] is Map<String, dynamic> &&
                (json['createdAt']['_seconds'] != null ||
                    json['createdAt']['seconds'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(
              ((json['createdAt']['_seconds'] ??
                          json['createdAt']['seconds'] ??
                          0) *
                      1000)
                  .toInt(),
            )
          : null,
    );
  }
}
