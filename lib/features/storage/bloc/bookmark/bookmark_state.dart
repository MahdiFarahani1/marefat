class BookMarkState {
  final List<Map<String, dynamic>> bookmarks;
  final bool isSaved;
  final BookMarkStatus status;

  const BookMarkState({
    this.bookmarks = const [],
    this.isSaved = false,
    this.status = BookMarkStatus.loading,
  });

  BookMarkState copyWith({
    List<Map<String, dynamic>>? bookmarks,
    bool? isSaved,
    BookMarkStatus? status,
  }) {
    return BookMarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isSaved: isSaved ?? this.isSaved,
      status: status ?? this.status,
    );
  }
}

enum BookMarkStatus {
  loading,
  success,
  error,
}
