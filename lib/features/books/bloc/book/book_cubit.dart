import 'package:bloc/bloc.dart';
import 'package:bookapp/features/books/repositoreis/book_repository.dart';

import 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository repo;
  BookCubit(this.repo) : super(BookInitial());

  Future<void> loadBooks() async {
    emit(BookLoading());
    try {
      final books = await repo.fetchBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
