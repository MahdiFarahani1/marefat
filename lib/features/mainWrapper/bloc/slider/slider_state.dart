part of 'slider_cubit.dart';

class SliderState {
  StatusSlider statusSlider;
  int currentIndex;

  SliderState({required this.currentIndex, required this.statusSlider});
  SliderState copyWith({StatusSlider? statusSlider, int? currentIndex}) {
    return SliderState(
        currentIndex: currentIndex ?? this.currentIndex,
        statusSlider: statusSlider ?? this.statusSlider);
  }
}

abstract class StatusSlider {}

class SliderLoading extends StatusSlider {}

class SliderLoaded extends StatusSlider {
  final List<SliderModel> sliders;
  final List<LastBookModel> books;

  SliderLoaded({required this.sliders, required this.books});
}

class SliderError extends StatusSlider {
  final String message;

  SliderError(this.message);
}
