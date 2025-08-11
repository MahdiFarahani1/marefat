import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'page_bookmark_state.dart';

class PageBookmarkCubit extends Cubit<PageBookmarkState> {
  final GetStorage _box;
  static const _bookmarkKey = 'bookmark';
  static const _pageSaveKey = 'pagesave';

  PageBookmarkCubit(this._box) : super(const PageBookmarkState());

  /// Load all bookmarks from storage
  void loadBookmarks() {
    try {
      emit(state.copyWith(status: PageBookmarkStatus.loading));

      final bookmarks = _readBookmarks();

      emit(state.copyWith(
        pageBookmarks: bookmarks,
        status: PageBookmarkStatus.success,
      ));
    } catch (e) {
      print('❌ loadBookmarks error: $e');
      emit(state.copyWith(status: PageBookmarkStatus.error));
    }
  }

  /// Check if a page is bookmarked
  void checkBookmark(String bookId, int pageNumber) {
    final saved = _box.read('$_pageSaveKey$bookId$pageNumber') ?? false;
    emit(state.copyWith(isSaved: saved));
  }

  /// Toggle bookmark state for a page
  void toggleBookmark(String bookName, String bookId, int pageNumber) {
    final saved = _box.read('$_pageSaveKey$bookId$pageNumber') ?? false;
    if (saved) {
      _remove(bookId, pageNumber);
    } else {
      _add(bookName, bookId, pageNumber);
    }
    loadBookmarks();
  }

  /// Remove a bookmark for a page
  void removeBookmark(String bookId, int pageNumber) {
    _remove(bookId, pageNumber);
    loadBookmarks();
  }

  void _add(String bookName, String bookId, int pageNumber) {
    final bookmarks = _readBookmarks();

    bookmarks.add({
      'bookName': bookName,
      'bookId': bookId,
      'pageNumber': pageNumber,
    });

    _box.write(_bookmarkKey, jsonEncode(bookmarks));
    _box.write('$_pageSaveKey$bookId$pageNumber', true);

    emit(state.copyWith(
      isSaved: true,
      pageBookmarks: bookmarks,
      status: PageBookmarkStatus.success,
    ));
  }

  void _remove(String bookId, int pageNumber) {
    _box.remove('$_pageSaveKey$bookId$pageNumber');

    final bookmarks = _readBookmarks();
    bookmarks.removeWhere(
      (b) => b['bookId'] == bookId && b['pageNumber'] == pageNumber,
    );

    _box.write(_bookmarkKey, jsonEncode(bookmarks));

    emit(state.copyWith(
      isSaved: false,
      pageBookmarks: bookmarks,
      status: PageBookmarkStatus.success,
    ));
  }

  List<Map<String, dynamic>> _readBookmarks() {
    final dynamic raw = _box.read(_bookmarkKey);

    try {
      if (raw == null) return <Map<String, dynamic>>[];

      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(
              decoded.map((e) => Map<String, dynamic>.from(e as Map)));
        }
        if (decoded is Map) {
          return [Map<String, dynamic>.from(decoded)];
        }
        return <Map<String, dynamic>>[];
      }

      if (raw is List) {
        return List<Map<String, dynamic>>.from(
          raw.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }

      if (raw is Map) {
        return [Map<String, dynamic>.from(raw)];
      }
    } catch (e) {
      print('❌ _readBookmarks decode error: $e');
    }
    return <Map<String, dynamic>>[];
  }
}
