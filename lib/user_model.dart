class UserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime? dateOfBirth;
  final String? gender;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.dateOfBirth,
    this.gender
  });
}
