import 'package:bookapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyProgressBox extends StatelessWidget {
  const EmptyProgressBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simple book icon
            Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Assets.newicons.bookOpenCover.image(
                        color: Theme.of(context).colorScheme.primary,
                        width: 40,
                        height: 40))
                .animate()
                .fadeIn(duration: 600.ms),

            const SizedBox(height: 24),

            // Title
            Text(
              'لم يتم تسجيل أي تقدم في الكتب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 700.ms, delay: 200.ms),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'ابدأ بقراءة كتاب لتتبع تقدمك هنا',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
