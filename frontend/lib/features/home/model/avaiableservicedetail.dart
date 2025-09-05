class ServiceDetailModel {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int category;
  final bool isActive;
  final String createdAt;

  ServiceDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.category,
    required this.isActive,
    required this.createdAt,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      category: json['category'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
    );
  }
}
