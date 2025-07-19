import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class BookDatabaseHelper {
  static final BookDatabaseHelper _instance = BookDatabaseHelper._internal();
  factory BookDatabaseHelper() => _instance;
  BookDatabaseHelper._internal();

  Database? _database;
  String? _currentBookId;

  String _zipPath(String id) => '/storage/emulated/0/Download/Books/$id.zip';
  String _extractDir(String id) => '/storage/emulated/0/Download/Books/tmp/$id';
  String _dbFilePath(String id) => '${_extractDir(id)}/b$id.sqlite';

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

  /// فقط یکبار دیتابیس باز میشه، اگه همون کتاب قبلاً باز شده، دوباره باز نمیشه
  Future<void> openDatabaseForBook(String id) async {
    if (_database != null && _currentBookId == id) {
      // دیتابیس از قبل برای همین کتاب باز شده
      return;
    }

    // بستن دیتابیس قبلی اگه وجود داشت
    await close();

    final dbPath = await _extractDatabaseFromZip(id);
    _database = await openDatabase(dbPath);
    _currentBookId = id;
  }

  Future<List<Map<String, dynamic>>> getBookPages() async {
    if (_database == null) {
      throw Exception('❌ دیتابیس هنوز باز نشده است!');
    }
    final result = await _database!.query('bpages', orderBy: 'id ASC');
    return result;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
    _currentBookId = null;
  }
}
