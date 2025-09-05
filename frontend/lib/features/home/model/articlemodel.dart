class ArticlePreviewModel {
  final int id;
  final String title;
  final String category;
  final DateTime createdAt;
  final String? previewImage;
  final String previewText;

  ArticlePreviewModel({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.previewImage,
    required this.previewText,
  });

  factory ArticlePreviewModel.fromJson(Map<String, dynamic> json) {
    return ArticlePreviewModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      previewImage: json['preview_image'],
      previewText: json['preview_text'],
    );
  }
}

class ArticleDetailModel {
  final int id;
  final String title;
  final String category;
  final DateTime createdAt;
  final String content;

  ArticleDetailModel({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.content,
  });

  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) {
    return ArticleDetailModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      content: json['content'],
    );
  }
}
