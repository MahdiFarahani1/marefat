class ArticleModel {
  final int id;
  final int categoryId;
  final String? title;
  final String? content;
  final String? summary;

  final DateTime dateTime;
  final String? updatedAt;
  final String? categoryTitle;

  ArticleModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.content,
    required this.summary,
    required this.dateTime,
    required this.updatedAt,
    required this.categoryTitle,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['date_time'] * 1000),
      updatedAt: json['updated_at'] ?? '',
      categoryTitle: json['category_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'content': content,
      'summary': summary,
      'date_time': dateTime.millisecondsSinceEpoch ~/ 1000,
      'updated_at': updatedAt,
      'category_title': categoryTitle,
    };
  }
}
