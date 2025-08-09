import 'package:bookapp/features/storage/repository/db_helper.dart';
import 'package:bookapp/shared/ui_helper/snackbar_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ModalComment {
  static void show(
    BuildContext context, {
    required int idBook,
    required String bookname,
    required int idPage,
    required bool updateMode,
    required int id,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        TextEditingController titleController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "تعليقك على ص $idPage من كتاب: $bookname",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان التعليق',
                    labelStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Comment input field
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'التعليق',
                    labelStyle: TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Action buttons (Submit & Cancel)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.text.trim().isNotEmpty) {
                          try {
                            // Get current date and time
                            final now = DateTime.now();
                            final dateTime =
                                '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

                            // Save comment to database
                            await DatabaseStorageHelper.insertComment(
                              bookname,
                              idPage.toDouble(),
                              titleController.text.trim().isEmpty
                                  ? 'بدون عنوان'
                                  : titleController.text.trim(),
                              controller.text.trim(),
                              dateTime,
                            );

                            Navigator.pop(context);

                            AppSnackBar.showSuccess(
                                context, "تم حفظ التعليق بنجاح");
                          } catch (e) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('خطا در ذخیره کامنت'),
                                backgroundColor: Colors.red.withOpacity(0.4),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        } else {}
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('حفظ'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        AppSnackBar.showWarning(
                            context, "لم يتم حفظ أي تعليق!");
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }
}
