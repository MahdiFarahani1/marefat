import 'package:bookapp/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

LinearGradient customGradinet() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.tertiary],
  );
}
