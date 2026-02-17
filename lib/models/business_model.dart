class BusinessModel {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String type;
  final String? status;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? subscription;
  final String? ownerId;

  BusinessModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.type,
    this.status,
    this.settings,
    this.subscription,
    this.ownerId,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      type: json['type'] ?? '',
      status: json['status'],
      settings: json['settings'],
      subscription: json['subscription'] != null
          ? Map<String, dynamic>.from(json['subscription'])
          : null,
      ownerId: json['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contact': contact,
      'type': type,
      'status': status,
      'settings': settings,
      'subscription': subscription,
      'ownerId': ownerId,
    };
  }
}
