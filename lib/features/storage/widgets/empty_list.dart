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
                  opacity: 0.7,
                  child: Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                    color: Theme.of(context).primaryColor,
                  ))
              .animate()
              .fade(duration: 600.ms)
              .slideY(begin: 0.2, duration: 600.ms),
          const SizedBox(height: 20),
          Opacity(
            opacity: 0.5,
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            )
                .animate()
                .fade(duration: 800.ms)
                .slideY(begin: 0.3, duration: 800.ms),
          ),
        ],
      ),
    );
  }
}
