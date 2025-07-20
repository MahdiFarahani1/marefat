class ContentState {
  final ContentStatus status;
  final List<Map<String, dynamic>> pages;
  final List<Map<String, dynamic>> groups;
  final double currentPage;
  final double scrollPosition;
  final String htmlContent;
  final bool showWebView;

  final bool showContentSettings;
  final bool isBookmarked;

  const ContentState({
    this.status = ContentStatus.init,
    this.pages = const [],
    this.groups = const [],
    this.currentPage = 1,
    this.scrollPosition = 1.0,
    this.htmlContent = '',
    this.showWebView = true,
    this.showContentSettings = false,
    this.isBookmarked = false,
  });

  ContentState copyWith({
    ContentStatus? status,
    List<Map<String, dynamic>>? pages,
    List<Map<String, dynamic>>? groups,
    double? currentPage,
    double? scrollPosition,
    String? htmlContent,
    bool? showWebView,
    bool? showContentSettings,
    bool? isBookmarked,
  }) {
    return ContentState(
      status: status ?? this.status,
      pages: pages ?? this.pages,
      groups: groups ?? this.groups,
      currentPage: currentPage ?? this.currentPage,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      htmlContent: htmlContent ?? this.htmlContent,
      showWebView: showWebView ?? this.showWebView,
      showContentSettings: showContentSettings ?? this.showContentSettings,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

enum ContentStatus { init, loading, success, error }
