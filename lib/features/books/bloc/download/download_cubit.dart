import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/books/model/model_books.dart';
import 'package:bookapp/features/books/widgets/file_downloader.dart';
import 'package:bookapp/shared/func/folder_check.dart';
import 'download_state.dart';

class DownloadCubit extends Cubit<Map<String, DownloadState>> {
  DownloadCubit() : super({});

  Future<void> checkIfDownloaded(String bookId, String pdf) async {
    final fileName = pdf.split('/').last;
    if (fileName.isEmpty) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    final exists = await file.exists();

    _updateState(bookId, (s) => s.copyWith(isDownloadedPdf: exists));
  }

  Future<void> checkIfBookDownloaded(
    String bookId,
  ) async {
    final base = await getBooksBaseDir();
    final file = File('${base.path}/$bookId.zip');
    final exists = await file.exists();

    _updateState(bookId, (s) => s.copyWith(isDownloadedBook: exists));
  }

  Future<void> startPdfDownload(String bookId, String url) async {
    final key = bookId;
    _updateState(
        key, (s) => s.copyWith(isDownloadingPdf: true, progressPdf: 0));

    await FileDownloader.downloadFile(
      url: url,
      onProgress: (progress) =>
          _updateState(key, (s) => s.copyWith(progressPdf: progress)),
      onComplete: (_) => _updateState(
        key,
        (s) => s.copyWith(
          isDownloadingPdf: false,
          progressPdf: 0,
          isDownloadedPdf: true,
        ),
      ),
    );
  }

  Future<void> startBookDownload(String bookId, String url) async {
    final key = bookId;
    print('🔄 Starting download for book: $bookId');
    print('📥 URL: $url');

    _updateState(
        key, (s) => s.copyWith(isDownloadingBook: true, progressBook: 0));

    try {
      await FileDownloader.downloadFile(
        url: url,
        fileName: '$bookId.zip',
        customDirectoryPath: (await getBooksBaseDir()).path,
        onProgress: (progress) {
          print('📊 Progress for $bookId: $progress%');
          _updateState(key, (s) => s.copyWith(progressBook: progress));
        },
        onComplete: (filePath) {
          print('✅ Download completed for $bookId');
          print('📁 File saved at: $filePath');
          _updateState(
            key,
            (s) => s.copyWith(
              isDownloadingBook: false,
              progressBook: 0,
              isDownloadedBook: true,
            ),
          );
        },
      );
    } catch (e) {
      print('❌ Download error for $bookId: $e');
      _updateState(
        key,
        (s) => s.copyWith(
          isDownloadingBook: false,
          progressBook: 0,
          isDownloadedBook: false,
        ),
      );
    }
  }

  Future<void> downloadAll(List<BookModel> books) async {
    for (final book in books) {
      final key = book.id.toString(); // Convert to string first
      final current = state[key];
      if (current == null ||
          (!current.isDownloadingBook && !current.isDownloadedBook)) {
        await startBookDownload(key, '${ConstantApp.downloadBook}$key');
        DatabaseStorageHelper.insertBookNames(book.title, book.id);
      }
    }
  }

  void _updateState(
      String key, DownloadState Function(DownloadState) updateFn) {
    final current = state[key] ?? DownloadState();
    emit({
      ...state,
      key: updateFn(current),
    });
  }
}
