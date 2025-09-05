class PersonnelModel {
  final String id;
  final String name;
  final String occupation;
  final String? photo;
  final String bio;
  final String? email;
  final String phone;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  PersonnelModel({
    required this.id,
    required this.name,
    required this.occupation,
    required this.photo,
    required this.bio,
    required this.email,
    required this.phone,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel(
      id: json['id'],
      name: json['name'],
      occupation: json['occupation'],
      photo: json['photo'],
      bio: json['bio'],
      email: json['email'],
      phone: json['phone'] ?? '',
      priority: json['priority'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'occupation': occupation,
      'photo': photo,
      'bio': bio,
      'email': email,
      'phone': phone,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
