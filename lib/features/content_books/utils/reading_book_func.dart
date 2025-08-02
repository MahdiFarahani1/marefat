import 'package:bookapp/features/content_books/bloc/content/content_cubit.dart';
import 'package:bookapp/features/content_books/widgets/save_reading_dilog.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

readBookDialog(BuildContext context, String bookname, String bookId) async {
  final db = await DatabaseStorageHelper.getAllReadingAbout(int.parse(bookId));

  if (db.isEmpty) {
    SaveReadingDilog().showContinueDialog(
      context,
      bookId: bookId,
      bookName: bookname,
      currentPage: context.read<ContentCubit>().state.currentPage,
      length: context.read<ContentCubit>().state.pages.length,
    );
  } else {
    final bookRead = db[0];

    if (bookRead['scrollposition'] <
        context.read<ContentCubit>().state.currentPage) {
      SaveReadingDilog().showContinueDialog(
        context,
        bookId: bookId,
        bookName: bookname,
        currentPage: context.read<ContentCubit>().state.currentPage,
        length: context.read<ContentCubit>().state.pages.length,
      );
    } else {
      Navigator.pop(context);
    }
  }
}
