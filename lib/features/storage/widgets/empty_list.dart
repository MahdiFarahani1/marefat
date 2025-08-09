import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyList {
  static Widget show(BuildContext context,
      {required String imagePath, required String message}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                  ))
              .animate()
              .fade(duration: 600.ms)
              .slideY(begin: 0.2, duration: 600.ms),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
            ),
          )
              .animate()
              .fade(duration: 800.ms)
              .slideY(begin: 0.3, duration: 800.ms),
        ],
      ),
    );
  }
}
