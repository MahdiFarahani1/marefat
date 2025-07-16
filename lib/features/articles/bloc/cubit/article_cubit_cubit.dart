import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:bookapp/features/articles/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'article_cubit_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit() : super(ArticleLoading());

  Future<void> fetchArticle() async {
    final ArticleRepository repository = ArticleRepository();

    emit(ArticleLoading());
    try {
      final articles = await repository.fetchArticle();
      emit(ArticleLoaded(articles));
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }
}
