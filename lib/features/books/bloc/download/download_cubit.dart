import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/features/books/model/model_books.dart';
import 'package:bookapp/features/books/widgets/file_downloader.dart';
import 'download_state.dart';

class DownloadCubit extends Cubit<Map<String, DownloadState>> {
  DownloadCubit() : super({});

  String _getKey(BookModel book) => book.id.toString();

  Future<void> checkIfDownloaded(BookModel book) async {
    final fileName = book.pdf?.split('/').last;
    if (fileName == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    final exists = await file.exists();

    _updateState(_getKey(book), (s) => s.copyWith(isDownloadedPdf: exists));
  }

  Future<void> checkIfBookDownloaded(BookModel book) async {
    final dir = '/storage/emulated/0/Download/Books';
    final file = File('$dir/${book.id}.zip');
    final exists = await file.exists();

    _updateState(_getKey(book), (s) => s.copyWith(isDownloadedBook: exists));
  }

  Future<void> startPdfDownload(BookModel book, String url) async {
    final key = _getKey(book);
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

  Future<void> startBookDownload(BookModel book, String url) async {
    final key = _getKey(book);
    _updateState(
        key, (s) => s.copyWith(isDownloadingBook: true, progressBook: 0));

    await FileDownloader.downloadFile(
      url: url,
      fileName: '${book.id}.zip',
      customDirectoryPath: '/storage/emulated/0/Download/Books',
      onProgress: (progress) =>
          _updateState(key, (s) => s.copyWith(progressBook: progress)),
      onComplete: (_) => _updateState(
        key,
        (s) => s.copyWith(
          isDownloadingBook: false,
          progressBook: 0,
          isDownloadedBook: true,
        ),
      ),
    );
  }

  Future<void> downloadAll(List<BookModel> books) async {
    for (final book in books) {
      final key = _getKey(book);
      final current = state[key];
      if (current == null ||
          (!current.isDownloadingBook && !current.isDownloadedBook)) {
        await startBookDownload(book, '${ConstantApp.downloadBook}$key');
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
