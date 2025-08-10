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
        tertiary: primary,

        primaryContainer: Colors.white,
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

  static ThemeData darkTheme() {
    const backgroundColor = Color.fromARGB(255, 46, 46, 46); // مشکی خالص
    const surfaceColor = Color(0xFF1E1E1E); // سطح‌ها مثل AppBar، کارت
    const grey = Color(0xFFB0B0B0); // برای متن غیرفعال
    const white = Colors.white;

    return ThemeData(
      useMaterial3: true,
      fontFamily: FontFamily.app,
      cardColor: surfaceColor,
      primaryColor: Colors.white,
      colorScheme: ColorScheme.dark(
        primaryContainer: Colors.grey.shade900,
        tertiary: Colors.white,
        primary: white,
        secondary: grey,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: white,
        onSecondary: grey,
        onSurface: white,
        onBackground: white,
        error: Colors.redAccent,
        onError: white,
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: surfaceColor,
        foregroundColor: white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        iconTheme: IconThemeData(color: white),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: white.withOpacity(0.08),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          return TextStyle(
            color: states.contains(MaterialState.selected) ? white : grey,
            fontWeight: states.contains(MaterialState.selected)
                ? FontWeight.bold
                : FontWeight.normal,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(MaterialState.selected) ? white : grey,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: white,
        unselectedItemColor: grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: white, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        titleLarge: TextStyle(color: white, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(color: white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        titleTextStyle: const TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: grey),
        labelStyle: const TextStyle(color: white),
      ),
      iconTheme: const IconThemeData(color: white),
    );
  }
}
