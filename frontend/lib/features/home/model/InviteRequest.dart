class InviteRequestModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String status;
  final DateTime createdAt;

  InviteRequestModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    required this.createdAt,
  });

  factory InviteRequestModel.fromJson(Map<String, dynamic> json) {
    return InviteRequestModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
