import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

class DatabaseStorageHelper {
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
    // در دسکتاپ باید FFI را مقداردهی کنیم
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      ffi.sqfliteFfiInit();
      databaseFactory = ffi.databaseFactoryFfi;
    }

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
    return await openDatabase(path, readOnly: false, version: 2);
  }

  static Future<List<Map<String, dynamic>>> getAllBooks() async {
    final db = await database;
    return await db.query('book');
  }

  static Future<List<Map<String, dynamic>>> getAllReading() async {
    final db = await database;
    return await db.query('reading');
  }

  static Future<List<Map<String, dynamic>>> getAllReadingAbout(
      int bookId) async {
    final db = await database;
    return await db.query('reading', where: 'book_id = ?', whereArgs: [bookId]);
  }

  static Future<List<Map<String, dynamic>>> getAllcomments() async {
    final db = await database;
    return await db.query('comment');
  }

  static Future<int> insertReading(
      String bookName, int bookID, double scrollPos, int length) async {
    final db = await database;

    // بررسی وجود book_id
    final List<Map<String, dynamic>> existing = await db.query(
      'reading',
      where: 'book_id = ?',
      whereArgs: [bookID],
    );

    if (existing.isNotEmpty) {
      // اگر وجود داشت، آپدیت کن
      return await db.update(
        'reading',
        {
          'book_name': bookName,
          'scrollposition': scrollPos,
          'pagesL': length,
        },
        where: 'book_id = ?',
        whereArgs: [bookID],
      );
    } else {
      // اگر نبود، اینسرت کن
      return await db.insert(
        'reading',
        {
          'book_name': bookName,
          'book_id': bookID,
          'scrollposition': scrollPos,
          'pagesL': length,
        },
      );
    }
  }

  static Future<int> insertComment(String bookName, double pageNumber,
      String title, String content, String time) async {
    final db = await database;
    return await db.insert(
      'comment',
      {
        'book_name': bookName,
        'title': title,
        'page_number': pageNumber,
        '_text': content,
        'date_time': time
      },
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

  static Future<int> insertBookNames(String bookName, int bookID) async {
    final db = await database;
    return await db.insert(
      'downloadedbook',
      {'book_name': bookName, 'book_id': bookID},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getaaaaaa() async {
    final db = await database;
    return await db.query('downloadedbook');
  }

  static Future<String> getBookNameWithId(int bookId) async {
    final db = await database;
    var list = await db.query(
      'downloadedbook',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );
    return list[0]['book_name'].toString();
  }

  static Future<int> deleteBook(int bookId) async {
    final db = await database;
    return await db.delete(
      'book',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );
  }

  static Future<void> deleteReading(int bookId, double pageNumber) async {
    final db = await database;
    await db.delete(
      'reading',
      where: 'book_id = ? AND scrollposition = ?',
      whereArgs: [bookId, pageNumber],
    );
  }

  static Future<void> deleteComment(String bookName, int pageNumber) async {
    final db = await database;
    await db.delete(
      'comment',
      where: 'book_name = ? AND page_number = ?',
      whereArgs: [bookName, pageNumber],
    );
  }

  static Future<int> updateComment(
      String bookName, int pageNumber, String newTitle, String newText) async {
    final db = await database;
    final now = DateTime.now();
    final dateTime =
        '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return await db.update(
      'comment',
      {
        'title': newTitle,
        '_text': newText,
        'date_time': dateTime,
      },
      where: 'book_name = ? AND page_number = ?',
      whereArgs: [bookName, pageNumber],
    );
  }

  static Future<List<Map<String, dynamic>>> getBookName() async {
    final db = await database;
    return await db.query('book');
  }
}
