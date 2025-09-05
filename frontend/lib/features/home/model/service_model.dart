class ServiceModel {
  final int id;
  final int user;
  final int category;
  final String categoryName;
  final String price;
  final String? description;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.user,
    required this.category,
    required this.categoryName,
    required this.price,
    this.description,
    required this.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      user: json['user'],
      category: json['category'],
      categoryName: json['category_name'],
      price: json['price'].toString(),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
