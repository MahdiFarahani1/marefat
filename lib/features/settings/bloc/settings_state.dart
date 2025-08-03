import 'dart:ui';

import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class SettingsState {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final int gradientIndex;

  final PageDirection pageDirection;
  final Color primry;
  Color pageColor;
  bool isApplying;
  SettingsState({
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.gradientIndex,
    required this.pageDirection,
    required this.primry,
    required this.pageColor,
    required this.isApplying,
  });

  factory SettingsState.initial() {
    return SettingsState(
      isApplying: false,
      pageColor: Colors.white,
      fontSize: 18,
      lineHeight: 1.5,
      fontFamily: 'لوتوس',
      gradientIndex: 0,
      pageDirection: PageDirection.horizontal,
      primry: SettingsCubit.backgrounds[0],
    );
  }

  SettingsState copyWith({
    bool? isApplying,
    Color? pageColor,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    int? gradientIndex,
    int? bgColorIndex,
    PageDirection? pageDirection,
  }) {
    final newGradientIndex = gradientIndex ?? this.gradientIndex;
    return SettingsState(
      isApplying: isApplying ?? this.isApplying,
      pageColor: pageColor ?? this.pageColor,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      gradientIndex: newGradientIndex,
      pageDirection: pageDirection ?? this.pageDirection,
      primry: SettingsCubit.backgrounds[newGradientIndex],
    );
  }
}
