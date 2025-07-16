part of 'article_cubit_cubit.dart';

abstract class ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<ArticleModel> articles;
  ArticleLoaded(this.articles);
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);
}
