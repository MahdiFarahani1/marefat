import 'package:bookapp/features/storage/bloc/page_bookmark/page_bookmark_state.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class PageBookmarkCubit extends Cubit<PageBookmarkState> {
  static const String pageSaveKey = 'pagesave';
  final GetStorage _box = GetStorage();

  // Singleton pattern for global state management
  static PageBookmarkCubit? _instance;
  static PageBookmarkCubit get instance {
    _instance ??= PageBookmarkCubit._internal();
    return _instance!;
  }

  PageBookmarkCubit._internal() : super(const PageBookmarkState());

  // Factory constructor for normal usage
  factory PageBookmarkCubit() => instance;

  Future<void> loadPageBookmarks() async {
    try {
      emit(state.copyWith(status: PageBookmarkStatus.loading));
      final pageBookmarks = await DatabaseStorageHelper.getAllpages();
      emit(state.copyWith(
        pageBookmarks: pageBookmarks,
        status: PageBookmarkStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: PageBookmarkStatus.error));
    }
  }

  void loadInitialState(String bookId, int pageNumber) {
    final savedFlag = _box.read('$pageSaveKey$bookId$pageNumber') ?? false;
    emit(state.copyWith(isSaved: savedFlag));
  }

  Future<void> togglePageBookmark(
      String bookName, String bookId, int pageNumber) async {
    try {
      final current = _box.read('$pageSaveKey$bookId$pageNumber') ?? false;

      if (current) {
        await _removePageBookmark(bookId, pageNumber);
      } else {
        await _addPageBookmark(bookName, bookId, pageNumber);
      }

      // Reload the list after toggle
      await loadPageBookmarks();
    } catch (e) {
      emit(state.copyWith(status: PageBookmarkStatus.error));
    }
  }

  Future<void> removePageBookmark(String bookId, int pageNumber) async {
    await _removePageBookmark(bookId, pageNumber);
  }

  Future<void> _addPageBookmark(
      String bookName, String bookId, int pageNumber) async {
    await _box.write('$pageSaveKey$bookId$pageNumber', true);
    await DatabaseStorageHelper.insertPage(
        bookName, int.parse(bookId), pageNumber.toDouble());

    final updatedPageBookmarks = await DatabaseStorageHelper.getAllpages();
    emit(state.copyWith(
      isSaved: true,
      pageBookmarks: updatedPageBookmarks,
      status: PageBookmarkStatus.success,
    ));
  }

  Future<void> _removePageBookmark(String bookId, int pageNumber) async {
    try {
      if (bookId.isEmpty) {
        emit(state.copyWith(status: PageBookmarkStatus.error));
        return;
      }

      await _box.remove('$pageSaveKey$bookId$pageNumber');
      await DatabaseStorageHelper.deletePage(
          int.parse(bookId), pageNumber.toDouble());

      final updatedPageBookmarks = await DatabaseStorageHelper.getAllpages();
      emit(state.copyWith(
        isSaved: false,
        pageBookmarks: updatedPageBookmarks,
        status: PageBookmarkStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: PageBookmarkStatus.error));
    }
  }
}
