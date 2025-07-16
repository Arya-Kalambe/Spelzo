import 'user_model.dart';

class UserManager {
  static UserModel user = UserModel(
    name: 'John Doe',
    email: 'john@example.com',
    phone: '9876543210',
    gender: 'Male',
    dob: '01/01/2000',
    imagePath: null,
  );

  static void updateUser(UserModel updatedUser) {
    user = updatedUser;
  }
}