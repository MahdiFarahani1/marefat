import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:bookapp/features/search/bloc/search_cubit.dart';
import 'package:sqflite/sqflite.dart';

class SearchRepository {
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

  static Future<List<SearchResultItem>> searchInAllBooks(String query) async {
    final dir = Directory('/storage/emulated/0/Download/Books/tmp/');
    final dbFiles = await _listSqliteFilesRecursively(dir);

    List<SearchResultItem> results = [];

    for (var file in dbFiles) {
      final db = await databaseFactory.openDatabase(file.path);
      final res = await db.rawQuery(
        "SELECT _text FROM bpages WHERE _text LIKE ?",
        ['%$query%'],
      );

      for (var row in res) {
        results.add(SearchResultItem(
          text: row['_text'] as String,
          bookName: p.basenameWithoutExtension(file.path),
        ));
      }

      await db.close();
    }

    return results;
  }

  static Future<List<SearchResultItem>> advancedSearch({
    required String query,
    required bool searchText,
    required bool searchTitle,
    required String bookPath, // "all" or a specific path
  }) async {
    final List<File> dbFiles;
    if (bookPath == "all") {
      final rootDir = Directory('/storage/emulated/0/Download/Books/tmp/');
      dbFiles = await _listSqliteFilesRecursively(rootDir);
    } else {
      dbFiles = [File(bookPath)];
    }

    List<SearchResultItem> results = [];

    for (var file in dbFiles) {
      final db = await databaseFactory.openDatabase(file.path);

      if (searchText) {
        final res = await db.rawQuery(
          "SELECT _text FROM bpages WHERE _text LIKE ?",
          ['%$query%'],
        );
        for (var row in res) {
          results.add(SearchResultItem(
            text: row['_text'] as String,
            bookName: p.basenameWithoutExtension(file.path),
          ));
        }
      }

      if (searchTitle) {
        final res = await db.rawQuery(
          "SELECT title FROM bgroups WHERE title LIKE ?",
          ['%$query%'],
        );
        for (var row in res) {
          results.add(SearchResultItem(
            text: row['title'] as String,
            bookName: p.basenameWithoutExtension(file.path),
          ));
        }
      }

      await db.close();
    }

    return results;
  }
}
