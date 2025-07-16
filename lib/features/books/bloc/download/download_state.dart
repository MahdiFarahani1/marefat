class DownloadState {
  final bool isDownloadingPdf;
  final bool isDownloadedPdf;
  final double progressPdf;

  final bool isDownloadingBook;
  final bool isDownloadedBook;
  final double progressBook;

  DownloadState({
    this.isDownloadingPdf = false,
    this.isDownloadedPdf = false,
    this.progressPdf = 0,
    this.isDownloadingBook = false,
    this.isDownloadedBook = false,
    this.progressBook = 0,
  });

  DownloadState copyWith({
    bool? isDownloadingPdf,
    bool? isDownloadedPdf,
    double? progressPdf,
    bool? isDownloadingBook,
    bool? isDownloadedBook,
    double? progressBook,
  }) {
    return DownloadState(
      isDownloadingPdf: isDownloadingPdf ?? this.isDownloadingPdf,
      isDownloadedPdf: isDownloadedPdf ?? this.isDownloadedPdf,
      progressPdf: progressPdf ?? this.progressPdf,
      isDownloadingBook: isDownloadingBook ?? this.isDownloadingBook,
      isDownloadedBook: isDownloadedBook ?? this.isDownloadedBook,
      progressBook: progressBook ?? this.progressBook,
    );
  }
}
