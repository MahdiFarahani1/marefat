import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../shared/utils/loading.dart';
import '../bloc/gallery_cubit.dart';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  @override
  void initState() {
    BlocProvider.of<GalleryCubit>(context).fetchGallery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading) {
            return Center(child: CustomLoading.fadingCircle(context));
          } else if (state is GalleryError) {
            return ApiErrorWidget(
              onRetry: () async {
                await BlocProvider.of<GalleryCubit>(context).fetchGallery();
              },
            );
          } else if (state is GalleryLoaded) {
            final photos = state.photos;
            return RefreshIndicator(
              onRefresh: () async {
                await BlocProvider.of<GalleryCubit>(context).fetchGallery();
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Hero(
                              tag: photo.id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ConstantApp.baseUrlGalleryContent}${photo.img}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image,
                                          size: 60, color: Colors.grey),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -15,
                              right: -5,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: customGradinet(),
                                        shape: BoxShape.circle),
                                    child: Assets.icons.send
                                        .image(
                                            color: Colors.white,
                                            width: 20,
                                            height: 20)
                                        .padAll(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Hero(
                        tag: photo.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            key: ValueKey(photo.img),
                            imageUrl:
                                '${ConstantApp.baseUrlGalleryContent}${photo.img}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
