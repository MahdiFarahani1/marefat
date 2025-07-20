class PageBookmarkState {
  final List<Map<String, dynamic>> pageBookmarks;
  final bool isSaved;
  final PageBookmarkStatus status;

  const PageBookmarkState({
    this.pageBookmarks = const [],
    this.isSaved = false,
    this.status = PageBookmarkStatus.loading,
  });

  PageBookmarkState copyWith({
    List<Map<String, dynamic>>? pageBookmarks,
    bool? isSaved,
    PageBookmarkStatus? status,
  }) {
    return PageBookmarkState(
      pageBookmarks: pageBookmarks ?? this.pageBookmarks,
      isSaved: isSaved ?? this.isSaved,
      status: status ?? this.status,
    );
  }
}

enum PageBookmarkStatus {
  loading,
  success,
  error,
}
