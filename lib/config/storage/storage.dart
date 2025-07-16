import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _box = GetStorage();

  // Keys
  static const _themeKey = 'isDarkMode';
  static const _fontSizeKey = 'fontSize';

  // Theme
  static bool get isDarkMode => _box.read(_themeKey) ?? false;
  static set isDarkMode(bool value) => _box.write(_themeKey, value);

  // Font Size
  static double get fontSize => _box.read(_fontSizeKey) ?? 16.0;
  static set fontSize(double value) => _box.write(_fontSizeKey, value);

  // برای پاک کردن همه تنظیمات (مثلاً در logout)
  static void clearAll() => _box.erase();
}
