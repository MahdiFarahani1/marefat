import 'dart:convert';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/questions/models/question_category_model.dart';
import 'package:bookapp/features/questions/models/question_model.dart';
import 'package:http/http.dart' as http;

class QuestionRepository {
  Future<List<QuestionCategoryModel>> fetchCategory() async {
    final response = await http.get(Uri.parse(ConstantApp.questionCategoryApi));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> questionCategoryList = data['questiongroup'];
      return questionCategoryList
          .map((item) => QuestionCategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load gallery');
    }
  }

  Future<List<QuestionModel>> fetchQuestions() async {
    final response = await http.get(Uri.parse(ConstantApp.questionApi));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> questionList = data['questions'];
      return questionList.map((item) => QuestionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load gallery');
    }
  }

  Future<List<QuestionModel>> fetchQuestionsSearch(String sw) async {
    final response = await http.get(Uri.parse(ConstantApp.questionSearch + sw));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> questionList = data['questions'];
      return questionList.map((item) => QuestionModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load gallery');
    }
  }
}
