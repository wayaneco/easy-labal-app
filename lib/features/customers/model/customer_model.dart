class CustomerModel {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String fullName;
  final String phone;
  final String? email;
  final String address;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.address,
    this.middleName,
    this.email,
  });
}
