import 'package:bookapp/shared/utils/images_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تصویر با سایه ظریف
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: AspectRatio(
                aspectRatio: 0.7,
                child: ImageNetworkCommon(imageurl: imageUrl),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.95, 0.95))
              .shimmer(duration: 1200.ms, delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 250.ms)
              .slideY(begin: 0.2),
          const SizedBox(height: 4),
          Text(
            author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey[700],
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .slideY(begin: 0.2),
        ],
      ),
    );
  }
}
