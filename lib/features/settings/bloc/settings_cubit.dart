import 'dart:ui';

import 'package:bookapp/config/theme/theme.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetStorage _box = GetStorage();

  SettingsCubit()
      : super(SettingsState(
          theme: AppTheme.lightTheme(backgrounds[0]),
          darkMode: false,
          isApplying: false,
          pageColor: Colors.white,
          fontSize: 18,
          lineHeight: 1.5,
          fontFamily: 'لوتوس',
          primrayIndex: 0,
          pageDirection: PageDirection.vertical,
          primry: backgrounds[0],
        ));

  void loadSettings() {
    bool isDarkMode = _box.read('darkmode') ?? false;
    emit(state.copyWith(
      isApplying: false,
      pageColor: Colors.white,
      fontSize: _box.read('fontSize') ?? 18,
      lineHeight: _box.read('lineHeight') ?? 1.5,
      fontFamily: _box.read('fontFamily') ?? 'لوتوس',
      gradientIndex: _box.read('gradientIndex') ?? 0,
      pageDirection: PageDirection.values[_box.read('pageDirection') ?? 0],
      primry: backgrounds[state.primrayIndex],
    ));
    emit(state.copyWith(
        primry: backgrounds[state.primrayIndex],
        darkMode: isDarkMode,
        theme: isDarkMode
            ? AppTheme.darkTheme()
            : AppTheme.lightTheme(backgrounds[state.primrayIndex])));
  }

  updateDarkMode(bool value) {
    _box.write('darkmode', value);

    emit(state.copyWith(darkMode: value));
    if (!value) {
      emit(state.copyWith(
          theme: AppTheme.lightTheme(backgrounds[state.primrayIndex])));
    } else {
      emit(state.copyWith(theme: AppTheme.darkTheme()));
    }
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

    emit(state.copyWith(
        gradientIndex: index,
        primry: backgrounds[index],
        theme: AppTheme.lightTheme(backgrounds[index])));
  }

  void updateBgColorIndex(int index) {
    _box.write('bgColorIndex', index);
    emit(state.copyWith(bgColorIndex: index));
  }

  void updateBgColor(Color color, String hexColor) {
    _box.write('hexColor', hexColor);
    emit(state.copyWith(pageColor: color));
  }

  void updatePageDirection(PageDirection direction) {
    _box.write('pageDirection', direction.index);
    emit(state.copyWith(pageDirection: direction));
  }

  void changeStateApply(bool isApply) {
    emit(state.copyWith(isApplying: isApply));
  }
}

List<Color> backgrounds = [
  Color.fromARGB(255, 12, 85, 138), // آبی تیره
  Color(0xFF2D6A4F),

  Color.fromARGB(255, 166, 138, 88), // قهوه‌ای/طلایی ملایم
  Color.fromARGB(255, 135, 140, 162), // خاکستری مایل به آبی
  Color(0xFF720026),

  Color(0xFFF46B45),
];
