import 'package:bloc/bloc.dart';
import 'package:bookapp/features/questions/bloc/questionItems/status_question.dart';
import 'package:bookapp/features/questions/models/question_category_model.dart';
import 'package:bookapp/features/questions/models/question_model.dart';
import 'package:bookapp/features/questions/repository/question_repository.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionState(status: QuestionsLoading(), id: 0));
  final QuestionRepository repository = QuestionRepository();

  Future<void> initalCategoryFetch() async {
    emit(state.copyWith(status: QuestionsLoading()));

    try {
      List<QuestionCategoryModel> categoryList =
          await repository.fetchCategory();

      final fillterListInit = categoryList
          .where(
            (item) => item.parentId == 0,
          )
          .toList();
      emit(state.copyWith(
          status: QuestionsCategoryLoaded(data: fillterListInit)));
    } catch (e) {
      emit(state.copyWith(
          status:
              QuestionsError(messageError: 'data!!!!!!!!!!!!!!!!!!!!!!!!!!!')));
    }
  }

  Future<void> categoryFetch(int id) async {
    emit(state.copyWith(status: QuestionsLoading(), id: id));

    try {
      List<QuestionModel> questionList = await repository.fetchQuestions();

      List<QuestionCategoryModel> categoryList =
          await repository.fetchCategory();
      final filteredCategories = categoryList
          .where((category) => category.parentId == state.id)
          .toList();
      if (filteredCategories.isEmpty) {
        final filteredQuestion = questionList
            .where((category) => category.categoryId == state.id)
            .toList();
        emit(state.copyWith(
            status: QuestionsContentLoaded(data: filteredQuestion)));
      } else {
        final fillterList = categoryList
            .where(
              (item) => item.parentId == id,
            )
            .toList();
        emit(
            state.copyWith(status: QuestionsCategoryLoaded(data: fillterList)));
      }
    } catch (e) {
      emit(state.copyWith(
          status:
              QuestionsError(messageError: 'data!!!!!!!!!!!!!!!!!!!!!!!!!!!')));
    }
  }
}
