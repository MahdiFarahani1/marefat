import 'package:bookapp/features/storage/bloc/bookmark/bookmark_state.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkCubit extends Cubit<BookMarkState> {
  static const String bookSaveKey = 'booksave';
  final GetStorage _box = GetStorage();

  // Singleton pattern for global state management
  static BookmarkCubit? _instance;
  static BookmarkCubit get instance {
    _instance ??= BookmarkCubit._internal();
    return _instance!;
  }

  BookmarkCubit._internal() : super(const BookMarkState());

  // Factory constructor for normal usage
  factory BookmarkCubit() => instance;

  Future<void> loadBookmarks() async {
    try {
      emit(state.copyWith(status: BookMarkStatus.loading));
      final bookmarks = await DatabaseHelper.getAllBooks();
      emit(state.copyWith(
        bookmarks: bookmarks,
        status: BookMarkStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: BookMarkStatus.error));
    }
  }

  void loadInitialState(String bookId) {
    final savedFlag = _box.read('$bookSaveKey$bookId') ?? false;
    emit(state.copyWith(isSaved: savedFlag));
  }

  Future<void> toggleBookmark(String bookName, String bookId) async {
    try {
      final current = _box.read('$bookSaveKey$bookId') ?? false;

      if (current) {
        await removeBookmark(bookId);
      } else {
        await addBookmark(bookName, bookId);
      }
    } catch (e) {
      emit(state.copyWith(status: BookMarkStatus.error));
    }

    await loadBookmarks();
  }

  Future<void> addBookmark(String bookName, String bookId) async {
    try {
      emit(state.copyWith(status: BookMarkStatus.loading));

      await _box.write('$bookSaveKey$bookId', true);
      await DatabaseHelper.insertBook(bookName, int.parse(bookId));

      final updatedBookmarks = await DatabaseHelper.getAllBooks();
      emit(state.copyWith(
        isSaved: true,
        bookmarks: updatedBookmarks,
        status: BookMarkStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: BookMarkStatus.error));
    }
  }

  Future<void> removeBookmark(String bookId) async {
    try {
      if (bookId.isEmpty) {
        emit(state.copyWith(status: BookMarkStatus.error));
        return;
      }

      await _box.remove('$bookSaveKey$bookId');
      await DatabaseHelper.deleteBook(int.parse(bookId));

      final updatedBookmarks = await DatabaseHelper.getAllBooks();
      emit(state.copyWith(
        isSaved: false,
        bookmarks: updatedBookmarks,
        status: BookMarkStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: BookMarkStatus.error));
    }
  }
}
