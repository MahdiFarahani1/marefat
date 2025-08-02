import 'package:bookapp/features/reading_progress/bloc/cubit/readingbook_cubit.dart';
import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveReadingDilog {
  void showContinueDialog(BuildContext context,
      {required double currentPage,
      required String bookId,
      required String bookName,
      required int length}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "هل ترغب في متابعة قراءة الكتاب؟",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "يمكنك استئناف القراءة من حيث توقفت أو البدء من جديد.",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("لا"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseStorageHelper.insertReading(
                          bookName, int.parse(bookId), currentPage, length);

                      context.read<ReadingbookCubit>().getReadingDataFromDb();

                      Navigator.of(context).pop(true);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("نعم"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
