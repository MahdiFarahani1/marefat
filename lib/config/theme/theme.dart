import 'package:bookapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(Color primary, Color unselected) {
    return ThemeData(
      fontFamily: FontFamily.app,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF1F1F6),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: const Color(0xFFC9B6E4),
        surface: Colors.white,
        background: const Color(0xFFF1F1F6),
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF1F1F6),
        indicatorColor: primary.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: unselected,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: primary);
          }
          return IconThemeData(color: unselected);
        }),
      ),
    );
  }

  static ThemeData darkTheme(Color primary, Color unselected) {
    return ThemeData(
      fontFamily: FontFamily.app,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF1E1E2E),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: const Color(0xFFC9B6E4),
        surface: const Color(0xFF2A2A40),
        background: const Color(0xFF1E1E2E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E2E),
        indicatorColor: primary.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: unselected,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: primary);
          }
          return IconThemeData(color: unselected);
        }),
      ),
    );
  }
}
