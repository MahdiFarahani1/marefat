import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> showInfoDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final theme = Theme.of(context);
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400, // محدودیت ارتفاع دیالوگ
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.newicons.termsInfo.image(
                  width: 60,
                  height: 60,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "موافق",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showConfirmDialog(BuildContext context,
      {required String title,
      required String content,
      required Future<void> Function() onPress}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Assets.newicons.triangleWarning
                  .image(color: Colors.orange.shade600, width: 20, height: 20),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('لا', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () async {
                await onPress();
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('نعم', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message,
  }) async {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomLoading.fadingCircle(context),
              if (message != null) ...[
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
