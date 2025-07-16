part of 'gallery_cubit.dart';

abstract class GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<GalleryPhoto> photos;
  GalleryLoaded(this.photos);
}

class GalleryError extends GalleryState {
  final String message;
  GalleryError(this.message);
}
