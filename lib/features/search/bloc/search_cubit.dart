import 'dart:io';
import 'package:bookapp/features/search/repository/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void reset() {
    emit(SearchInitial());
  }

  Future<void> quickSearch(String query) async {
    emit(SearchLoading());
    try {
      print('SearchCubit: Starting quick search for: $query');
      final results = await SearchRepository.searchInAllBooks(query);
      print(
          'SearchCubit: Quick search completed with ${results.length} results');
      emit(SearchSuccess(results));
    } catch (e) {
      print('SearchCubit: Quick search error: $e');
      emit(SearchError('خطأ في البحث: $e'));
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
      print('SearchCubit: Starting advanced search for: $query');
      final results = await SearchRepository.advancedSearch(
        query: query,
        searchText: searchText,
        searchTitle: searchTitle,
        bookPath: selectedBookPath,
      );
      print(
          'SearchCubit: Advanced search completed with ${results.length} results');
      emit(SearchSuccess(results));
    } catch (e) {
      print('SearchCubit: Advanced search error: $e');
      emit(SearchError('خطأ في البحث المتقدم: $e'));
    }
  }

  // Close all open database connections
  Future<void> closeDatabases() async {
    try {
      await SearchRepository.closeAllDatabases();
    } catch (e) {
      print('Error closing databases: $e');
    }
  }

  @override
  Future<void> close() {
    closeDatabases();
    return super.close();
  }
}
