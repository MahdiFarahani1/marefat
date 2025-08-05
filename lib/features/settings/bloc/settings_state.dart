import 'dart:ui';

import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class SettingsState {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final int primrayIndex;
  bool darkMode;
  ThemeData theme;
  final PageDirection pageDirection;
  final Color primry;
  Color pageColor;
  bool isApplying;
  SettingsState(
      {required this.darkMode,
      required this.fontSize,
      required this.lineHeight,
      required this.fontFamily,
      required this.primrayIndex,
      required this.pageDirection,
      required this.primry,
      required this.pageColor,
      required this.isApplying,
      required this.theme});

  SettingsState copyWith({
    ThemeData? theme,
    bool? darkMode,
    bool? isApplying,
    Color? pageColor,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    int? gradientIndex,
    int? bgColorIndex,
    Color? primry,
    PageDirection? pageDirection,
  }) {
    final newGradientIndex = gradientIndex ?? primrayIndex;
    return SettingsState(
      theme: theme ?? this.theme,
      isApplying: isApplying ?? this.isApplying,
      pageColor: pageColor ?? this.pageColor,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      primrayIndex: newGradientIndex,
      pageDirection: pageDirection ?? this.pageDirection,
      primry: primry ?? this.primry,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
