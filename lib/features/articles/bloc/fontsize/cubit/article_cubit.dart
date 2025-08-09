import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';

class ArticleFontSizeCubit extends Cubit<double> {
  final GetStorage _box = GetStorage();
  static const String _key = 'articleFontSize';

  ArticleFontSizeCubit() : super(22) {
    // خواندن سایز ذخیره‌شده
    double? savedSize = _box.read(_key);
    if (savedSize != null) {
      emit(savedSize);
    }
  }

  void plusFontSize() {
    if (state < 32) {
      double newSize = state + 1;
      _box.write(_key, newSize);
      emit(newSize);
    }
  }

  void minusFontSize() {
    if (state > 14) {
      double newSize = state - 1;
      _box.write(_key, newSize);
      emit(newSize);
    }
  }
}
