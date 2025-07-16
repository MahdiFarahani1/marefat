import 'package:bloc/bloc.dart';
import 'package:bookapp/features/questions/models/question_model.dart';
import 'package:bookapp/features/questions/repository/question_repository.dart';

part 'question_search_state.dart';

class QuestionSearchCubit extends Cubit<QuestionSearchState> {
  QuestionSearchCubit() : super(QuestionSearchInit());

  Future<void> serchData(String sw) async {
    emit(QuestionSearchLoading());
    try {
      final List<QuestionModel> questions =
          await QuestionRepository().fetchQuestionsSearch(sw);
      emit(QuestionSearchLoaded(data: questions));
    } catch (e) {
      emit(QuestionSearchError());
    }
  }
}
