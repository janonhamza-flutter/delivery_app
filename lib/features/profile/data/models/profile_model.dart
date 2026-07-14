class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String specialization;
  final String experience;
  final bool isActive;
  final String shopName;
  final String shopAddress;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.specialization,
    required this.experience,
    required this.isActive,
    required this.shopName,
    required this.shopAddress,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phone: json["phone"],
      email: json["email"],
      specialization: json["specialization"],
      experience: json["experience"],
      isActive: json["is_active"],
      shopName: json["shop"]["name"],
      shopAddress: json["shop"]["address"],
    );
  }
}
