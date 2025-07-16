import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageNetworkCommon extends StatelessWidget {
  final String imageurl;
  final double? width, height;
  const ImageNetworkCommon(
      {super.key, required this.imageurl, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      width: width ?? 130,
      height: height ?? 180,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width ?? 130,
          height: height ?? 180,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width ?? 130,
        height: height ?? 180,
        color: Colors.grey[200],
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
