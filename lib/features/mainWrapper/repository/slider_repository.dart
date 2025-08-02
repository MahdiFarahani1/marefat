import 'dart:convert';
import 'package:bookapp/features/mainWrapper/model/slider_model.dart';
import 'package:http/http.dart' as http;

class SliderRepository {
  static const String apiUrl = "https://maarifadeen.com/api/home";

  static Future<List<SliderModel>> fetchSliders() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List slidersJson = data['sliders'];

      return slidersJson.map((json) => SliderModel.fromJson(json)).toList();
    } else {
      throw Exception("خطا در دریافت اسلایدر");
    }
  }

  static Future<List<LastBookModel>> fetchLastBooks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List slidersJson = data['last_books'];

      return slidersJson.map((json) => LastBookModel.fromJson(json)).toList();
    } else {
      throw Exception("خطا در دریافت اسلایدر");
    }
  }
}
