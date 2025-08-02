import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';

part 'readingbook_state.dart';

class ReadingbookCubit extends Cubit<ReadingbookState> {
  ReadingbookCubit() : super(ReadingbookState());

  Future<void> getReadingDataFromDb() async {
    emit(state.copyWith(status: ReadingbookStatus.loading));

    try {
      final books = await DatabaseStorageHelper.getAllReading();

      emit(state.copyWith(
        status: ReadingbookStatus.success,
        books: books,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReadingbookStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
