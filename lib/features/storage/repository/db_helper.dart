import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  // اسم دیتابیس شما
  static const String dbName = "bookmark.sqlite";

  // بارگذاری دیتابیس
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // مسیر پوشه داده دستگاه
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    // اگر دیتابیس وجود نداشت، از assets کپی کن
    if (!File(path).existsSync()) {
      // خواندن فایل دیتابیس از assets
      ByteData data = await rootBundle.load('assets/database/$dbName');

      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // نوشتن دیتابیس در مسیر مورد نظر
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // باز کردن دیتابیس
    return await openDatabase(path, readOnly: false);
  }

  static Future<List<Map<String, dynamic>>> getAllBooks() async {
    final db = await database;
    return await db.query('book');
  }

  static Future<List<Map<String, dynamic>>> getAllpages() async {
    final db = await database;
    return await db.query('page');
  }

  static Future<int> insertPage(
      String bookName, int bookID, double scrollPos) async {
    final db = await database;
    return await db.insert(
      'page',
      {'book_name': bookName, 'book_id': bookID, 'scrollposition': scrollPos},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> insertBook(String bookName, int bookID) async {
    final db = await database;
    return await db.insert(
      'book',
      {'book_name': bookName, 'book_id': bookID},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> deleteBook(int bookId) async {
    final db = await database;
    return await db.delete(
      'book',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );
  }

  static Future<int> deletePage(int bookId) async {
    final db = await database;
    return await db.delete(
      'page',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );
  }
}
