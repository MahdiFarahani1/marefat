part of 'question_cubit.dart';

class QuestionState {
  QeustionStatus status;
  int id;

  QuestionState({required this.id, required this.status});

  QuestionState copyWith({
    QeustionStatus? status,
    int? id,
  }) {
    return QuestionState(
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}
