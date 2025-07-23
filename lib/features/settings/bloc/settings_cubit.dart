import 'dart:ui';

import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetStorage _box = GetStorage();

  SettingsCubit() : super(SettingsState.initial()) {
    loadSettings();
  }

  void loadSettings() {
    emit(SettingsState(
      fontSize: _box.read('fontSize') ?? 18,
      lineHeight: _box.read('lineHeight') ?? 1.5,
      fontFamily: _box.read('fontFamily') ?? 'جَزَلة',
      gradientIndex: _box.read('gradientIndex') ?? 0,
      bgColorIndex: _box.read('bgColorIndex') ?? 2,
      pageDirection: PageDirection.values[_box.read('pageDirection') ?? 1],
      primry: SettingsCubit.backgrounds[0][0],
      unselected: SettingsCubit.backgrounds[0][1],
    ));
  }

  void updateFontSize(double value) {
    _box.write('fontSize', value);
    emit(state.copyWith(fontSize: value));
  }

  void updateLineHeight(double value) {
    _box.write('lineHeight', value);
    emit(state.copyWith(lineHeight: value));
  }

  void updateFontFamily(String value) {
    _box.write('fontFamily', value);
    emit(state.copyWith(fontFamily: value));
  }

  void updateGradientIndex(int index) {
    _box.write('gradientIndex', index);
    emit(state.copyWith(gradientIndex: index));
  }

  void updateBgColorIndex(int index) {
    _box.write('bgColorIndex', index);
    emit(state.copyWith(bgColorIndex: index));
  }

  void updatePageDirection(PageDirection direction) {
    _box.write('pageDirection', direction.index);
    emit(state.copyWith(pageDirection: direction));
  }

  static List<List<Color>> backgrounds = [
    [
      Color(0xFF141E30), // آبی نفتی تیره
      Color(0xFF243B55), // آبی خاکستری
    ],
    [
      Color(0xFF373B44), // شروع: خاکستری تیره
      Color(0xFF4286F4), // پایان: آبی روشن
    ],
    // خاکستری نقره‌ای به سفید
    [
      Color(0xFF1F4037), // سبز تیره
      Color(0xFF99F2C8), // سبز نعنایی روشن
    ],

    [
      Color(0xFFF46B45), // نارنجی مایل به قرمز
      Color(0xFFEEA849), // طلایی گرم
    ],
    // نارنجی روشن به کرم طلایی
    [
      Color(0xFF616161), // خاکستری تیره
      Color(0xFF9BC5C3), // سبز آبی ملایم
    ],
  ];
  static final bgColorsPage = [
    const Color(0xFFB0BEC5),
    const Color(0xFFFFF3CD),
    Colors.white,
  ];
}
