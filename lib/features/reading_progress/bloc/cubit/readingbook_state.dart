part of 'readingbook_cubit.dart';

enum ReadingbookStatus { initial, loading, success, error }

class ReadingbookState {
  final ReadingbookStatus status;
  final List<Map<String, dynamic>> books; // فرض می‌کنیم دیتا به این شکله
  final String? errorMessage;

  ReadingbookState({
    this.status = ReadingbookStatus.initial,
    this.books = const [],
    this.errorMessage,
  });

  ReadingbookState copyWith({
    ReadingbookStatus? status,
    List<Map<String, dynamic>>? books,
    String? errorMessage,
  }) {
    return ReadingbookState(
      status: status ?? this.status,
      books: books ?? this.books,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
