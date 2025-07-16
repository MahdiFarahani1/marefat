import 'package:bookapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: FontFamily.c,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      background: AppColors.backgroundLight,
      onPrimary: AppColors.textDark,
      onSecondary: AppColors.textDark,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      indicatorColor: AppColors.tertiary,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          );
        }
        return const TextStyle(
          color: AppColors.unselected,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return const IconThemeData(color: AppColors.unselected);
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: const Color(0xFF2A2A40),
      background: AppColors.backgroundDark,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      indicatorColor: AppColors.tertiary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          );
        }
        return const TextStyle(
          color: AppColors.unselected,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: AppColors.primary);
        }
        return const IconThemeData(color: AppColors.unselected);
      }),
    ),
  );
}
