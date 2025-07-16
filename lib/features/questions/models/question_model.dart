class QuestionModel {
  final int id;
  final int categoryId;
  final String title;
  final String content;
  final String answer;

  QuestionModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.answer,
  });

  // ساخت مدل از JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      content: json['content'],
      answer: json['answer'],
    );
  }

  // تبدیل مدل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'content': content,
      'answer': answer,
    };
  }
}
