import 'dart:convert';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:http/http.dart' as http;

class ArticleRepository {
  Future<List<ArticleModel>> fetchArticle() async {
    final response = await http.get(Uri.parse(ConstantApp.articlesApi));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articleList = data['posts'];
      return articleList.map((item) => ArticleModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load gallery');
    }
  }
}
