import 'package:bookapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(Color primary) {
    return ThemeData(
      fontFamily: FontFamily.app,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF1F1F6), // خاکستری خیلی روشن
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        surfaceTintColor: Colors.transparent, // این خط مهم
      ),

      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: const Color(0xFFC9B6E4),
        surface: Colors.white, // کارت‌ها، AppBar و...
        background: Colors.white, // مثل Dialog یا Dropdown
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF1F1F6),
        indicatorColor: primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            );
          }
          return const TextStyle(color: Colors.grey);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: Colors.grey);
        }),
      ),
    );
  }

  static ThemeData darkTheme(Color primary, Color unselected) {
    return ThemeData(
      fontFamily: FontFamily.app,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212), // تیره‌تر از بک‌گراند
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: const Color(0xFFC9B6E4),
        surface: const Color(0xFF1E1E2E), // کارت‌ها و AppBar
        background: const Color(0xFF1E1E2E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
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
