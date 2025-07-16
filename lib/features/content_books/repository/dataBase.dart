import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class BookDatabaseHelper {
  Database? _database;

  /// مسیر فایل زیپ کتاب
  String _zipPath(String id) => '/storage/emulated/0/Download/Books/$id.zip';

  /// مسیر استخراج موقت دیتابیس
  String _extractDir(String id) => '/storage/emulated/0/Download/Books/tmp/$id';

  /// مسیر دیتابیس استخراج‌شده
  String _dbFilePath(String id) => '${_extractDir(id)}/b$id.sqlite';

  /// اکسترکت فایل ZIP و آماده‌سازی دیتابیس
  Future<String> _extractDatabaseFromZip(String id) async {
    final zipFile = File(_zipPath(id));
    if (!await zipFile.exists()) {
      throw Exception('📦 فایل ZIP کتاب یافت نشد!');
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final outputDir = _extractDir(id);

    for (final file in archive) {
      final filename = file.name;
      final outPath = p.join(outputDir, filename);
      if (file.isFile) {
        final outFile = File(outPath);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }

    final dbPath = _dbFilePath(id);
    if (!await File(dbPath).exists()) {
      throw Exception('❌ فایل دیتابیس داخل زیپ پیدا نشد!');
    }

    return dbPath;
  }

  /// باز کردن دیتابیس
  Future<void> openDatabaseForBook(String id) async {
    final dbPath = await _extractDatabaseFromZip(id);
    _database = await openDatabase(dbPath);
  }

  /// گرفتن همه‌ی صفحات کتاب از جدول bpages
  Future<List<Map<String, dynamic>>> getBookPages() async {
    if (_database == null) {
      throw Exception('❌ دیتابیس هنوز باز نشده است!');
    }

    final result = await _database!.query('bpages', orderBy: 'id ASC');
    return result; // فقط text رو اگر خواستی بعداً فیلتر کن
  }

  /// بستن دیتابیس
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
