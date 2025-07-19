import 'dart:convert';
import 'package:bookapp/features/content_books/repository/dataBase.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final String bookId;
  final BookDatabaseHelper repository;

//  final SettingsController settingsController;
  late InAppWebViewController inAppWebViewController;
  ContentCubit({
    required this.bookId,
    required this.repository,

    // required this.settingsController,
  }) : super(const ContentState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: ContentStatus.loading));

    // final bookmarks = Constants.localStorage.read('bookmarks') ?? {};
    //  final isBookmarked = bookmarks.containsKey(bookId.toString());

    try {
      await repository.openDatabaseForBook(bookId);
      // final dbPath = await repository.getDatabasePath(bookId);
      final loadedPages = await repository.getBookPages();
      // final loadedGroups = await repository.getGroups(dbPath);

      final html = await buildHtmlContent(loadedPages);

      emit(state.copyWith(
        status: ContentStatus.success,
        pages: loadedPages,
        //   groups: loadedGroups,
        htmlContent: html,
        //  isBookmarked: isBookmarked,
      ));
    } catch (e) {
      print('❌ Error loading content: $e');
      emit(state.copyWith(status: ContentStatus.error));
    }
  }

  Future<String> buildHtmlContent(List<Map<String, dynamic>> pages) async {
    final StringBuffer buffer = StringBuffer();
    final bool vertical = true;
    final String bookText =
        vertical ? 'book_text_vertical' : 'book_text_horizontal';
    final String bookContainer =
        vertical ? 'book-container-vertical' : 'book-container-horizontal';
    final String bookPage = vertical
        ? 'BookPage-vertical book-page-vertical'
        : 'BookPage-horizontal book-page-horizontal';

    List<dynamic> bookmarks = [];
    // final String? savedBookmarks = Constants.localStorage.read('bookmark');
    // if (savedBookmarks != null) {
    //   final decoded = jsonDecode(savedBookmarks);
    //   bookmarks = decoded is List ? decoded : [decoded];
    // }

    print(pages.length);
    for (int i = 0; i < pages.length; i++) {
      bool isMarked = false;
      // bool isMarked =
      //     bookmarks.any((b) => b['bookId'] == bookId && b['pageNumber'] == i);
      //   final bgColor = settingsController.backgroundColor.value.toCssHex();

      buffer.write("""
        <div class='$bookPage book_page' data-page='$i' style='color: black !important; background-color: grey !important;' id='page_$i'>
          ${isMarked ? "<div class='book-mark add_fav' id='book-mark_$i'></div>" : "<div class='book-mark' id='book-mark_$i'></div>"}
          <div class='comment-button'></div>
          <span class='page-number'>${i + 1}</span>
          <br>
          <div class='$bookText text_style' id='page___$i' style="font-size:${'settingsController.fontSize'}px !important; line-height:${'settingsController.lineHeight'} !important;">
            <div style='text-align:center;'><img class='pageLoading' src='asset://images/loader.gif'></div>
          </div>
        </div>
      """);
    }

    // final fontCss = await loadFont();

    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>''</style>
        <link rel="stylesheet" href="asset://web/css/bootstrap.rtl.min.css">
        <link rel="stylesheet" href="asset://web/css/mhebooks.css">
      </head>
      <body onload="replaceContent()" dir="rtl">
        <div class="$bookContainer">
          ${buffer.toString()}
        </div>
        <script src="asset://web/js/jquery-3.5.1.min.js"></script>
        <script src="asset://web/js/bootstrap.bundle.min.js"></script>
        <script src="asset://web/js/main.js"></script>
      </body>
      </html>
    ''';
  }

  // Future<String> loadFont() async {
  //   String fontPath = 'assets/fonts/SegoeUI.woff2';
  //   String mime = 'font/woff2';

  //   switch (settingsController.fontFamily.value) {
  //     case 'لوتوس':
  //       fontPath = 'assets/fonts/Lotus-Light.woff2';
  //       break;
  //     case 'البهيج':
  //       fontPath = 'assets/fonts/BahijMuna-Bold.woff2';
  //       break;
  //   }

  //   final mainFont = await rootBundle.load(fontPath);
  //   final aboFont = await rootBundle.load('assets/fonts/abo.ttf');

  //   final mainFontBase64 = _getFontUriAsBase64(mainFont, mime);
  //   final aboFontBase64 = _getFontUriAsBase64(aboFont, 'font/truetype');

  //   return '''
  //     @font-face {
  //       font-family: "${settingsController.fontFamily.value}";
  //       src: url("$mainFontBase64") format('woff2');
  //     }
  //     @font-face {
  //       font-family: "AboThar";
  //       src: url("$aboFontBase64") format('truetype');
  //     }
  //     .AboThar {
  //       font-family: "AboThar" !important;
  //       color: #4caf50 !important;
  //       font-size: 20px;
  //     }
  //     body, p, div, span {
  //       font-family: "${settingsController.fontFamily.value}" !important;
  //       direction: rtl;
  //     }
  //   ''';
  // }

  String _getFontUriAsBase64(ByteData data, String mime) {
    final buffer = data.buffer;
    return "data:$mime;charset=utf-8;base64,${base64Encode(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes))}";
  }

  void handleBack() {
    emit(state.copyWith(showWebView: false));
  }
}
