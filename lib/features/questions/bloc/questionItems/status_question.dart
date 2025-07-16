abstract class QeustionStatus {}

class QuestionsError extends QeustionStatus {
  String messageError;
  QuestionsError({required this.messageError});
}

class QuestionsLoading extends QeustionStatus {}

class QuestionsCategoryLoaded extends QeustionStatus {
  dynamic data;
  QuestionsCategoryLoaded({required this.data});
}

class QuestionsContentLoaded extends QeustionStatus {
  dynamic data;
  QuestionsContentLoaded({required this.data});
}
