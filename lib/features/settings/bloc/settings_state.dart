import 'dart:ui';

import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';

class SettingsState {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final int gradientIndex;
  final int bgColorIndex;
  final PageDirection pageDirection;
  final Color primry;
  final Color unselected;

  SettingsState({
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.gradientIndex,
    required this.bgColorIndex,
    required this.pageDirection,
    required this.primry,
    required this.unselected,
  });

  factory SettingsState.initial() {
    return SettingsState(
      fontSize: 18,
      lineHeight: 1.5,
      fontFamily: 'جَزَلة',
      gradientIndex: 0,
      bgColorIndex: 2,
      pageDirection: PageDirection.horizontal,
      primry: SettingsCubit.backgrounds[0][0],
      unselected: SettingsCubit.backgrounds[0][1],
    );
  }

  SettingsState copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    int? gradientIndex,
    int? bgColorIndex,
    PageDirection? pageDirection,
  }) {
    final newGradientIndex = gradientIndex ?? this.gradientIndex;
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      gradientIndex: newGradientIndex,
      bgColorIndex: bgColorIndex ?? this.bgColorIndex,
      pageDirection: pageDirection ?? this.pageDirection,
      primry: SettingsCubit.backgrounds[newGradientIndex][0],
      unselected: SettingsCubit.backgrounds[newGradientIndex][1],
    );
  }
}
