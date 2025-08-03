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
      isApplying: false,
      pageColor: Colors.white,
      fontSize: _box.read('fontSize') ?? 18,
      lineHeight: _box.read('lineHeight') ?? 1.5,
      fontFamily: _box.read('fontFamily') ?? 'لوتوس',
      gradientIndex: _box.read('gradientIndex') ?? 0,
      pageDirection: PageDirection.values[_box.read('pageDirection') ?? 1],
      primry: SettingsCubit.backgrounds[0],
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

  void updateBgColor(Color color) {
    // _box.write('bgColorIndex', index);
    emit(state.copyWith(pageColor: color));
  }

  void updatePageDirection(PageDirection direction) {
    _box.write('pageDirection', direction.index);
    emit(state.copyWith(pageDirection: direction));
  }

  void changeStateApply(bool isApply) {
    emit(state.copyWith(isApplying: isApply));
  }

  static List<Color> backgrounds = [
    Color(0xFF141E30),
    Color(0xFFEEA849), // طلایی گرم
    Color(0xFFF46B45), // نارنجی مایل به قرمز
    Color(0xFF9BC5C3), // سبز آبی ملایم

    Color.fromARGB(255, 18, 41, 78), // پایان: آبی روشن
  ];
}
