// ✅ user_model.dart
class UserModel {
  String name;
  String email;
  String phone;
  String? gender;
  String? dob;
  String? imagePath;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.dob,
    this.imagePath,
  });

  // ✅ Add this method
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? dob,
    String? imagePath,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}