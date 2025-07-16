import 'package:bookapp/features/books/model/book_item_model.dart';

abstract class DownloadedBooksState {
  const DownloadedBooksState();
}

class DownloadedBooksLoading extends DownloadedBooksState {}

class DownloadedBooksLoaded extends DownloadedBooksState {
  final List<BookItem> books;
  const DownloadedBooksLoaded(this.books);
}

class DownloadedBooksError extends DownloadedBooksState {
  final String message;
  const DownloadedBooksError(this.message);
}
