part of 'search_cubit.dart';

sealed class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<SearchResultItem> results;
  SearchSuccess(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchResultItem {
  final String text;
  final String bookName;

  SearchResultItem({required this.text, required this.bookName});
}
