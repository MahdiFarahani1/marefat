import 'package:bookapp/features/mainWrapper/model/slider_model.dart';
import 'package:bookapp/features/mainWrapper/repository/slider_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit()
      : super(SliderState(currentIndex: 0, statusSlider: SliderLoading()));

  Future<void> loadSliders() async {
    try {
      emit(state.copyWith(statusSlider: SliderLoading()));
      final sliders = await SliderRepository.fetchSliders();
      emit(state.copyWith(statusSlider: SliderLoaded(sliders)));
    } catch (e) {
      emit(state.copyWith(statusSlider: SliderError(e.toString())));
    }
  }

  indicatorChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
