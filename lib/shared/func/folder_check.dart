import 'dart:io';

Future<bool> folderExists(String folderName) async {
  final directory =
      Directory('/storage/emulated/0/Download/Books/tmp/$folderName');
  return directory.exists();
}
