import 'dart:ui';
import 'package:bookapp/core/constant/const_class.dart';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
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
    super.initState();
    context.read<GalleryCubit>().fetchGallery();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading) {
            return Center(child: CustomLoading.fadingCircle(context));
          } else if (state is GalleryError) {
            return ApiErrorWidget(
              onRetry: () async {
                await context.read<GalleryCubit>().fetchGallery();
              },
            );
          } else if (state is GalleryLoaded) {
            final photos = state.photos;

            return RefreshIndicator(
              onRefresh: () => context.read<GalleryCubit>().fetchGallery(),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  final imageUrl =
                      '${ConstantApp.baseUrlGalleryContent}${photo.img}';

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
                                onTap: () {
                                  Share.share('$imageUrl}');
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.primaryColor),
                                    child: Assets.newicons.paperPlaneTop
                                        .image(
                                            color:
                                                theme.scaffoldBackgroundColor,
                                            width: 20,
                                            height: 20)
                                        .padAll(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    child: Hero(
                      tag: photo.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => shimmerBox(),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 40),
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

  Widget shimmerBox({double width = double.infinity, double height = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
