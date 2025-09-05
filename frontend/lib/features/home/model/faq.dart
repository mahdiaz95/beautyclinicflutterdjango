class FAQModel {
  final int id;
  final String question;
  final String answer;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) => FAQModel(
        id: json['id'],
        question: json['question'],
        answer: json['answer'],
      );
}

class FAQCategoryModel {
  final int id;
  final String name;
  final List<FAQModel> faqs;

  FAQCategoryModel({
    required this.id,
    required this.name,
    required this.faqs,
  });

  factory FAQCategoryModel.fromJson(Map<String, dynamic> json) =>
      FAQCategoryModel(
        id: json['id'],
        name: json['name'],
        faqs: (json['faqs'] as List)
            .map((item) => FAQModel.fromJson(item))
            .toList(),
      );
}
