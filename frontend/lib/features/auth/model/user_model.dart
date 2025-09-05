import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final DateTime? lastLogin;
  final DateTime dateJoined;
  final String codemeli;
  final String phoneNumber;
  final String? city;
  final DateTime? birthDate;
  final String? job;
  final String? sex;
  final String referralCode;
  final String? referrer;
  final List<String>? referrals;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
    required this.isSuperuser,
    this.lastLogin,
    required this.dateJoined,
    required this.codemeli,
    required this.phoneNumber,
    this.city,
    this.birthDate,
    this.job,
    this.sex,
    required this.referralCode,
    this.referrer,
    this.referrals,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      isActive: map['is_active'] ?? false,
      isStaff: map['is_staff'] ?? false,
      isSuperuser: map['is_superuser'] ?? false,
      lastLogin: map['last_login'] != null
          ? DateTime.tryParse(map['last_login'])
          : null,
      dateJoined: DateTime.parse(
          map['date_joined'] ?? DateTime.now().toIso8601String()),
      codemeli: map['codemeli'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      city: map['city'],
      birthDate: map['birth_date'] != null
          ? DateTime.tryParse(map['birth_date'])
          : null,
      job: map['job'],
      sex: map['sex'],
      referralCode: map['referral_code'] ?? '',
      referrer: map['referrer'],
      referrals:
          map['referrals'] != null ? List<String>.from(map['referrals']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'last_login': lastLogin?.toIso8601String(),
      'date_joined': dateJoined.toIso8601String(),
      'codemeli': codemeli,
      'phone_number': phoneNumber,
      'city': city,
      'birth_date': birthDate?.toIso8601String(),
      'job': job,
      'sex': sex,
      'referral_code': referralCode,
      'referrer': referrer,
      'referrals': referrals,
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
