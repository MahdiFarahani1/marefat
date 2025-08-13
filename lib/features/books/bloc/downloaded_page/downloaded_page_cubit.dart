import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:archive/archive_io.dart';
import 'package:bookapp/features/books/bloc/downloaded_page/downloaded_page_state.dart';
import 'package:bookapp/features/books/model/book_item_model.dart';
import 'package:bookapp/features/books/model/model_books.dart';
import 'package:bookapp/shared/func/folder_check.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';

class DownloadedBooksCubit extends Cubit<DownloadedBooksState> {
  DownloadedBooksCubit() : super(DownloadedBooksLoading());

  Future<void> loadDownloadedBooks() async {
    try {
      emit(DownloadedBooksLoading());
      final List<BookModel> allBooks = await BookRepository().fetchBooks();
      final base = await getBooksBaseDir();
      final directory = base;
      if (!await directory.exists()) {
        emit(const DownloadedBooksLoaded([]));
        return;
      }

      final zipFiles = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.zip'));

      final List<BookItem> bookItems = [];

      for (final zipFile in zipFiles) {
        try {
          final bytes = await zipFile.readAsBytes();
          final archive = ZipDecoder().decodeBytes(bytes);

          final idMatch = RegExp(r'b?(\d+)\.zip').firstMatch(zipFile.path);
          final id = idMatch?.group(1);
          if (id == null) continue;

          final imageFile = archive.files.firstWhere(
            (f) =>
                f.name.toLowerCase().contains(id) &&
                (f.name.toLowerCase().endsWith('.jpg') ||
                    f.name.toLowerCase().endsWith('.jpeg') ||
                    f.name.toLowerCase().endsWith('.png')),
            orElse: () => ArchiveFile('notfound', 0, Uint8List(0)),
          );

          if (imageFile.isFile && imageFile.content.isNotEmpty) {
            final imageBytes = imageFile.content as List<int>;
            final bookInfo = allBooks.firstWhere((b) => b.id.toString() == id);

            bookItems.add(BookItem(
              id: id,
              imageData: imageBytes,
              title: bookInfo.title,
              author: bookInfo.writer,
              date: bookInfo.dateTime.toString(),
            ));
          }
        } catch (e) {
          emit(DownloadedBooksError(e.toString()));
        }
      }

      emit(DownloadedBooksLoaded(bookItems));
    } catch (e) {
      emit(DownloadedBooksError(e.toString()));
    }
  }
}
