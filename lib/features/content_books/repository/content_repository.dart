// import 'dart:io';

// import 'package:bookapp/features/content_books/repository/constants.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart' as sqflite;

// class ContentRepository {
//   // late final dynamic _dbFactory = _initDbFactory();

//   // dynamic _initDbFactory() {
//   //   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//   //     sqfliteFfiInit();
//   //     return databaseFactoryFfi;
//   //   } else {
//   //     return sqflite.databaseFactory;
//   //   }
//   // }
//   Future<Directory> getWindowsSaveDirectory() async {
//     final appSupportDir = await getApplicationSupportDirectory();

//     final alraheeqDir = Directory(join(appSupportDir.path, 'alraheeq'));

//     if (!await alraheeqDir.exists()) {
//       await alraheeqDir.create(recursive: true);
//     }

//     return alraheeqDir;
//   }

//   /// Returns the path of the SQLite database based on book ID
//   Future<String> getDatabasePath(int bookId) async {
//     Directory dir;

//     if (Platform.isAndroid) {
//       // ترجیحاً از getExternalStorageDirectory استفاده کن
//       dir = await getExternalStorageDirectory() ??
//           await getApplicationDocumentsDirectory();
//     } else if (Platform.isIOS) {
//       dir = await getApplicationDocumentsDirectory();
//     } else if (Platform.isWindows) {
//       dir = await getWindowsSaveDirectory();
//     } else {
//       dir = await getDownloadsDirectory() ??
//           await getApplicationDocumentsDirectory();
//     }

//     final dbName = 'b$bookId.sqlite';
//     final dbPath = join(dir.path, dbName);

//     final file = File(dbPath);
//     if (!await file.exists()) {
//       throw Exception('فایل دیتابیس $dbName پیدا نشد، لطفا ابتدا دانلود کنید.');
//     }

//     return dbPath;
//   }

//   /// Loads the pages table from the SQLite database
//   Future<List<Map<String, dynamic>>> getPages(String dbPath) async {
//     final db = await DBHelper.dbFactory.openDatabase(dbPath);
//     return await db.query('bpages');
//   }

//   /// Loads the groups table from the SQLite database
//   Future<List<Map<String, dynamic>>> getGroups(String dbPath) async {
//     final db = await DBHelper.dbFactory.openDatabase(dbPath);
//     return await db.query('bgroups');
//   }
// }

// void toggleBookmark(dynamic bookId, String bookTitle) {
//   final id = bookId.toString();

//   final bookmarks = Map<String, String>.from(
//     Constants.localStorage.read('bookmarks') ?? {},
//   );

//   if (bookmarks.containsKey(id)) {
//     bookmarks.remove(id);
//   } else {
//     bookmarks[id] = bookTitle;
//   }

//   Constants.localStorage.write('bookmarks', bookmarks);
// }
