import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bookapp/features/search/bloc/search_cubit.dart';
import 'package:sqflite/sqflite.dart';

class SearchRepository {
  // Keep track of open database connections
  static final Map<String, Database> _openDatabases = {};

  static Future<List<File>> _listSqliteFilesRecursively(Directory dir) async {
    List<File> files = [];

    final entities = dir.listSync(recursive: true, followLinks: false);
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.sqlite')) {
        files.add(entity);
      }
    }

    return files;
  }

  // Get or create database connection
  static Future<Database> _getDatabase(String filePath) async {
    if (_openDatabases.containsKey(filePath)) {
      final db = _openDatabases[filePath]!;
      // Check if database is still open
      try {
        await db.rawQuery('SELECT 1');
        return db;
      } catch (e) {
        // Database is closed, remove it and create new one
        print('Database ${filePath} is closed, removing from cache');
        _openDatabases.remove(filePath);
      }
    }

    try {
      final db = await databaseFactory.openDatabase(filePath);
      _openDatabases[filePath] = db;
      print('Opened database: $filePath');
      return db;
    } catch (e) {
      print('Error opening database $filePath: $e');
      rethrow;
    }
  }

  // Close all open databases
  static Future<void> closeAllDatabases() async {
    print('Closing ${_openDatabases.length} open databases');
    for (final entry in _openDatabases.entries) {
      try {
        final db = entry.value;
        await db.close();
        print('Closed database: ${entry.key}');
      } catch (e) {
        print('Error closing database ${entry.key}: $e');
      }
    }
    _openDatabases.clear();
    print('All databases closed');
  }

  static Future<List<SearchResultItem>> searchInAllBooks(String query) async {
    print('Starting search in all books for query: $query');
    final dir = Directory('/storage/emulated/0/Download/Books/tmp/');

    if (!await dir.exists()) {
      print('Books directory does not exist: ${dir.path}');
      return [];
    }

    final dbFiles = await _listSqliteFilesRecursively(dir);
    print('Found ${dbFiles.length} database files');

    List<SearchResultItem> results = [];

    for (var file in dbFiles) {
      try {
        print('Searching in database: ${file.path}');
        final db = await _getDatabase(file.path);
        String rawName = p.basenameWithoutExtension(file.path);

        String bookId =
            rawName.startsWith('b') ? rawName.substring(1) : rawName;
        final res = await db.rawQuery(
          "SELECT page, _text FROM bpages WHERE _text LIKE ?",
          ['%$query%'],
        );

        print('Found ${res.length} results in ${file.path}');
        for (var row in res) {
          results.add(SearchResultItem(
              pageNumber: row['page'] as dynamic,
              text: row['_text'] as String,
              bookName: bookId,
              bookId: bookId));
        }
      } catch (e) {
        print('Error searching in database ${file.path}: $e');
        // Remove problematic database from cache
        _openDatabases.remove(file.path);
      }
    }

    print('Total search results: ${results.length}');
    return results;
  }

  static Future<List<SearchResultItem>> advancedSearch({
    required String query,
    required bool searchText,
    required bool searchTitle,
    required String bookPath, // "all" or a specific path
  }) async {
    print('Starting advanced search for query: $query');
    print(
        'Search options: text=$searchText, title=$searchTitle, bookPath=$bookPath');

    final List<File> dbFiles;
    if (bookPath == "all") {
      final rootDir = Directory('/storage/emulated/0/Download/Books/tmp/');
      if (!await rootDir.exists()) {
        print('Books directory does not exist: ${rootDir.path}');
        return [];
      }
      dbFiles = await _listSqliteFilesRecursively(rootDir);
    } else {
      final file = File(bookPath);
      if (!await file.exists()) {
        print('Book file does not exist: $bookPath');
        return [];
      }
      dbFiles = [file];
    }

    print('Found ${dbFiles.length} database files to search');

    List<SearchResultItem> results = [];

    for (var file in dbFiles) {
      try {
        print('Searching in database: ${file.path}');
        final db = await _getDatabase(file.path);
        String rawName = p.basenameWithoutExtension(file.path);

        String bookId =
            rawName.startsWith('b') ? rawName.substring(1) : rawName;
        if (searchText) {
          final res = await db.rawQuery(
            "SELECT page, _text FROM bpages WHERE _text LIKE ?",
            ['%$query%'],
          );

          print('Found ${res.length} text results in ${file.path}');
          for (var row in res) {
            results.add(SearchResultItem(
                pageNumber: row['page'] as dynamic,
                text: row['_text'] as String,
                bookName: bookId,
                bookId: bookId));
          }
        }

        if (searchTitle) {
          final res = await db.rawQuery(
            "SELECT page, title FROM bgroups WHERE title LIKE ?",
            ['%$query%'],
          );
          print('Found ${res.length} title results in ${file.path}');
          for (var row in res) {
            results.add(SearchResultItem(
                pageNumber: row['page'] as dynamic,
                text: row['title'] as String,
                bookName: bookId,
                bookId: bookId));
          }
        }
      } catch (e) {
        print('Error searching in database ${file.path}: $e');
        // Remove problematic database from cache
        _openDatabases.remove(file.path);
      }
    }

    print('Total advanced search results: ${results.length}');
    return results;
  }
}
