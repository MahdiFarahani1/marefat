import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/gallery_photo.dart';
import '../repository/gallery_repository.dart';

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit() : super(GalleryLoading());

  Future<void> fetchGallery() async {
    final GalleryRepository repository = GalleryRepository();

    emit(GalleryLoading());
    try {
      final photos = await repository.fetchGallery();
      emit(GalleryLoaded(photos));
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }
}
