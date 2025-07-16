import 'package:bookapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class ApiErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ApiErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // انیمیشن خطا
              Lottie.asset(
                Assets.lottie.error404,
                width: 160,
                height: 160,
                fit: BoxFit.contain,
                repeat: true,
              ),

              const SizedBox(height: 16),

              // عنوان خطا
              const Text(
                'حدث خطأ!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 8),

              // توضیح خطا
              const Text(
                'فشل الاتصال بالخادم. حاول مرة أخرى من فضلك.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 20),

              // دکمه تلاش مجدد
              Directionality(
                textDirection: TextDirection.ltr,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('حاول مرة أخرى'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(begin: const Offset(0.95, 0.95)),
    );
  }
}
