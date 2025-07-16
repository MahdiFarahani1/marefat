class QuestionCategoryModel {
  final int id;
  final String lang;
  final int parentId;
  final String title;
  final String logo;
  final String source;
  final String slug;
  final int show2site;
  final int idShow;
  final int questionCount;

  QuestionCategoryModel({
    required this.id,
    required this.lang,
    required this.parentId,
    required this.title,
    required this.logo,
    required this.source,
    required this.slug,
    required this.show2site,
    required this.idShow,
    required this.questionCount,
  });

  // ساخت مدل از JSON
  factory QuestionCategoryModel.fromJson(Map<String, dynamic> json) {
    return QuestionCategoryModel(
      id: json['id'],
      lang: json['lang'],
      parentId: json['parent_id'],
      title: json['title'],
      logo: json['logo'],
      source: json['source'],
      slug: json['slug'],
      show2site: json['show2site'],
      idShow: json['id_show'],
      questionCount: json['question_count'],
    );
  }

  // تبدیل مدل به JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lang': lang,
      'parent_id': parentId,
      'title': title,
      'logo': logo,
      'source': source,
      'slug': slug,
      'show2site': show2site,
      'id_show': idShow,
      'question_count': questionCount,
    };
  }
}
