import 'dart:io';

import 'package:bookapp/features/books/bloc/download/download_state.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void handleDownloadOrOpen(BuildContext context, DownloadState downloadState,
    String url, String fileNamee, Function onTap) async {
  final fileName = fileNamee;
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/$fileName';
  final file = File(filePath);

  if (await file.exists()) {
    await OpenFile.open(filePath);
  } else if (!downloadState.isDownloadingPdf &&
      !downloadState.isDownloadedPdf) {
    onTap();
  }
}

Future<void> handleBookDownload(
  BuildContext context,
  DownloadState downloadState,
  String url,
  String fileNamee,
  Function onTap,
) async {
  final downloadsDir = Directory('/storage/emulated/0/Download/Books');

  if (!await downloadsDir.exists()) {
    await downloadsDir.create(recursive: true);
  }

  final filePath = '${downloadsDir.path}/$fileNamee';
  final file = File(filePath);

  if (await file.exists()) {
    return;
  } else if (!downloadState.isDownloadingBook &&
      !downloadState.isDownloadedBook) {
    onTap();
  }
}
