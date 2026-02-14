class UserModel {
  final String? uid;
  final String email;
  final String? displayName;
  final String? role;
  final String? photoURL;
  final String? phoneNumber;
  final String? businessId;

  UserModel({
    this.uid,
    required this.email,
    this.displayName,
    this.role,
    this.photoURL,
    this.phoneNumber,
    this.businessId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'] ?? '',
      displayName: json['displayName'],
      role: json['role'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
      businessId: json['businessId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'businessId': businessId,
    };
  }
}
