import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<Directory> getBooksBaseDir() async {
  if (Platform.isAndroid) {
    final base = await getApplicationDocumentsDirectory() ??
        await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'Books'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
  if (Platform.isIOS) {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'Books'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
  // Windows/macOS/Linux
  final base = await getApplicationSupportDirectory();
  final dir = Directory(p.join(base.path, 'Books'));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}

Future<String> getBookZipPath(String bookId) async {
  final base = await getBooksBaseDir();
  return p.join(base.path, '$bookId.zip');
}

Future<Directory> getBookTmpDir(String bookId) async {
  final base = await getBooksBaseDir();
  final tmp = Directory(p.join(base.path, 'tmp', bookId));
  if (!await tmp.exists()) {
    await tmp.create(recursive: true);
  }
  return tmp;
}

Future<String> getBookCoverPath(String bookId) async {
  final tmp = await getBookTmpDir(bookId);
  return p.join(tmp.path, '$bookId.jpg');
}

Future<bool> folderExists(String folderName) async {
  final directory = await getBookTmpDir(folderName);
  return directory.exists();
}
