class UserModel {
  final String id;
  final String name;
  final String mobileNumber;
  final String? email;
  final String? profilePicture;
  final bool isVerified;
  
  UserModel({
    required this.id,
    required this.name,
    required this.mobileNumber,
    this.email,
    this.profilePicture,
    this.isVerified = false,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email'],
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile_number': mobileNumber,
      'email': email,
      'profile_picture': profilePicture,
      'is_verified': isVerified,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? email,
    String? profilePicture,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
