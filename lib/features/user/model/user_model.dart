class UserModel {
  String staffId;
  String userId;
  String firstName;
  String? middleName;
  String lastName;
  String fullName;
  String phone;
  String email;
  String address;
  String employmentDate;
  List<dynamic> roles;
  List<dynamic>? branches;

  UserModel({
    required this.staffId,
    required this.userId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.employmentDate,
    required this.roles,
    required this.branches,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      staffId: json['staff_id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      middleName: json['middle_name'] ?? "",
      lastName: json['last_name'],
      fullName: json['full_name'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      employmentDate: json['employment_date'],
      roles: json['roles'],
      branches: json['branches'],
    );
  }
}
