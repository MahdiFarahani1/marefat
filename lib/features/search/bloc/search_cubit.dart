import 'dart:io';
import 'package:bookapp/features/search/repository/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> quickSearch(String query) async {
    emit(SearchLoading());
    try {
      final results = await SearchRepository.searchInAllBooks(query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> advancedSearch({
    required String query,
    required bool searchText,
    required bool searchTitle,
    required String selectedBookPath, // "all" means all books
  }) async {
    emit(SearchLoading());
    try {
      final results = await SearchRepository.advancedSearch(
        query: query,
        searchText: searchText,
        searchTitle: searchTitle,
        bookPath: selectedBookPath,
      );
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
