class BusinessModel {
  final String id;
  final String name;
  final String address;
  final String contact;
  final String type;
  final Map<String, dynamic>? settings;
  final String? ownerId;

  BusinessModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.type,
    this.settings,
    this.ownerId,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      type: json['type'] ?? '',
      settings: json['settings'],
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
      'settings': settings,
      'ownerId': ownerId,
    };
  }
}
