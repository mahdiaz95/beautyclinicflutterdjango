class PortfolioItem {
  final int id;
  final String title;
  final String mediaType;
  final String media;
  final String description;
  final DateTime createdAt;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.mediaType,
    required this.media,
    required this.description,
    required this.createdAt,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id: json['id'],
      title: json['title'],
      mediaType: json['media_type'],
      media: json['media'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'media_type': mediaType,
        'media': media,
        'description': description,
        'created_at': createdAt.toIso8601String(),
      };
}
