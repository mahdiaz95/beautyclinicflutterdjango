class Promotion {
  final int id;
  final String mediaType;
  final String file;
  final String caption;
  final DateTime createdAt;

  Promotion({
    required this.id,
    required this.mediaType,
    required this.file,
    required this.caption,
    required this.createdAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      mediaType: json['media_type'],
      file: json['file'],
      caption: json['caption'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'file': file,
      'caption': caption,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
