import 'dart:convert';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/books/model/model_books.dart';
import 'package:http/http.dart' as http;

class BookRepository {
  Future<List<BookModel>> fetchBooks() async {
    final res = await http.get(Uri.parse(ConstantApp.booksAPi));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final books =
          (data['books'] as List).map((e) => BookModel.fromJson(e)).toList();

      // مرتب‌سازی بر اساس idShow به صورت صعودی
      books.sort((a, b) => a.idShow.compareTo(b.idShow));

      return books;
    } else {
      throw Exception('خطأ في جلب الكتب');
    }
  }

  String imageUrl(String imgPath) {
    return ConstantApp.upload + imgPath;
  }
}
