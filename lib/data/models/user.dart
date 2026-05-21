class UserModel {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String profileImage;

  UserModel({
    this.id = '',
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.profileImage = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'profile_image': profileImage,
    };
  }
}
