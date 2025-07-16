part of 'question_search_cubit.dart';

abstract class QuestionSearchState {}

class QuestionSearchLoading extends QuestionSearchState {}

class QuestionSearchError extends QuestionSearchState {}

class QuestionSearchLoaded extends QuestionSearchState {
  dynamic data;
  QuestionSearchLoaded({required this.data});
}

class QuestionSearchInit extends QuestionSearchState {}
