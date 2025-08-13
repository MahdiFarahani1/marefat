import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bookapp/features/content_books/repository/dataBase.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart'; // یادت نره مسیرتو تنظیم کنی
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final String bookId;
  final BookDatabaseHelper repository;
  final SettingsCubit settingsCubit;
  final BuildContext context;
  late InAppWebViewController inAppWebViewController;
  late final StreamSubscription settingsSubscription;

  ContentCubit({
    required this.bookId,
    required this.repository,
    required this.settingsCubit,
    required this.context,
  }) : super(const ContentState()) {
    _init(context);

    settingsSubscription = settingsCubit.stream.listen((settingsState) {
      _rebuildHtml(settingsState, context);
    });
  }

  void updateCurrentPage(double newPage) {
    emit(state.copyWith(currentPage: newPage));
  }

  Future<void> _init(BuildContext context) async {
    emit(state.copyWith(status: ContentStatus.loading));
    try {
      print('🔄 Initializing content for book: $bookId');

      // Check if book file exists first
      final baseDir = await repository.getBaseBooksDir();
      final zipPath = p.join(baseDir.path, '$bookId.zip');
      if (!File(zipPath).existsSync()) {
        throw Exception('📦 فایل کتاب $bookId.zip یافت نشد! مسیر: $zipPath');
      }

      await repository.openDatabaseForBook(bookId);
      final loadedPages = await repository.getBookPages();
      print('📚 Loaded ${loadedPages.length} pages');

      final settingsState = settingsCubit.state;
      final html = await buildHtmlContent(loadedPages, context,
          fontSize: settingsState.fontSize,
          lineHeight: settingsState.lineHeight,
          vertical: context.read<SettingsCubit>().state.pageDirection ==
              PageDirection.vertical,
          backgroundColor: settingsState.pageColor);

      emit(state.copyWith(
        status: ContentStatus.success,
        pages: loadedPages,
        htmlContent: html,
      ));
      print('✅ Content initialized successfullyaaaaaa');
    } catch (e) {
      print('❌ Error loading content: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      emit(state.copyWith(status: ContentStatus.error));
    }
  }

  Future<void> _rebuildHtml(
      SettingsState settingsState, BuildContext context) async {
    if (state.pages.isEmpty) return;

    final html = await buildHtmlContent(state.pages, context,
        fontSize: settingsState.fontSize,
        lineHeight: settingsState.lineHeight,
        vertical: context.read<SettingsCubit>().state.pageDirection ==
            PageDirection.vertical,
        backgroundColor: settingsState.pageColor);

    emit(state.copyWith(htmlContent: html));

    // بازنشانی محتوا داخل WebView
    if (state.showWebView) {
      inAppWebViewController.loadData(
        data: html,
        mimeType: 'text/html',
        encoding: 'utf-8',
      );
    }
  }

  Future<String> buildHtmlContent(
      List<Map<String, dynamic>> pages, BuildContext context,
      {required double fontSize,
      required double lineHeight,
      required bool vertical,
      required Color backgroundColor}) async {
    GetStorage box = GetStorage();
    final StringBuffer buffer = StringBuffer();
    String bgColorHex = box.read('hexColor') ??
        '#${backgroundColor.value.toRadixString(16).substring(2)}';
    final String bookText =
        vertical ? 'book_text_vertical' : 'book_text_horizontal';
    final String bookContainer =
        vertical ? 'book-container-vertical' : 'book-container-horizontal';
    final String bookPage = vertical
        ? 'BookPage-vertical book-page-vertical'
        : 'BookPage-horizontal book-page-horizontal';

    List<dynamic> bookmarks = [];

    GetStorage getStorage = GetStorage();

    final String? savedBookmarks = getStorage.read('bookmark');

    DatabaseStorageHelper db = DatabaseStorageHelper();
    if (savedBookmarks != null) {
      final decoded = jsonDecode(savedBookmarks);
      bookmarks = decoded is List ? decoded : [decoded];
    }

    for (int i = 0; i < pages.length; i++) {
      bool isBookmarked = bookmarks.any(
        (b) => b['bookId'] == bookId && b['pageNumber'] == i,
      );
      buffer.write("""
        <div class='$bookPage book_page' data-page='$i' style='color: black !important; background-color: $bgColorHex !important;' id='page_$i'>
         ${isBookmarked ? "<div class='book-mark add_fav' id='book-mark_$i'></div>" : "<div class='book-mark' id='book-mark_$i'></div>"}
          <div class='comment-button'></div>
          <span class='page-number'>${i + 1}</span>
          <br>
          <div class='$bookText text_style' id='page___$i' style="font-size:${fontSize}px !important; line-height:${lineHeight} !important;">
            <div style='text-align:center;'><img class='pageLoading' src='asset://images/loader.gif'></div>
          </div>
        </div>
      """);
    }
    final fontCss =
        await loadFont(context.read<SettingsCubit>().state.fontFamily);

    return '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
           <style>$fontCss</style>
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

  Future<String> loadFont(String fontfamily) async {
    String fontPath = 'assets/fonts/SegoeUI.woff2';
    String fontMime = 'font/woff2';

    switch (fontfamily) {
      case 'لوتوس':
        fontPath = 'assets/fonts/Lotus-Light.woff2';
        break;
      case 'البهيج':
        fontPath = 'assets/fonts/BahijMuna-Bold.woff2';
        break;
      case 'دجلة':
      default:
        fontPath = 'assets/fonts/SegoeUI.woff2';
    }

    final ByteData mainFont = await rootBundle.load(fontPath);
    final ByteData aboFont = await rootBundle.load('assets/fonts/abo.ttf');

    final String mainFontBase64 = _getFontUriAsBase64(mainFont, fontMime);
    final String aboFontBase64 = _getFontUriAsBase64(aboFont, 'font/truetype');

    return '''
      @font-face {
        font-family: "$fontfamily";
        src: url("$mainFontBase64") format('woff2');
      }
      @font-face {
        font-family: "AboThar";
        src: url("$aboFontBase64") format('truetype');
      }
      .AboThar {
        font-family: "AboThar" !important;
          color: #4caf50 !important;
        font-size: 20px;
      }
      body, p, div, span {
        font-family: "$fontfamily" !important;
        direction: rtl;
      }
    ''';
  }

  String _getFontUriAsBase64(ByteData data, String mime) {
    final buffer = data.buffer;
    return "data:$mime;charset=utf-8;base64,${base64Encode(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes))}";
  }

  void handleBack() {
    emit(state.copyWith(showWebView: false));
  }

  @override
  Future<void> close() {
    settingsSubscription.cancel();
    return super.close();
  }
}
