import 'dart:io';
import 'package:bookapp/features/content_books/view/content_page.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:path/path.dart' as p;
import 'package:bookapp/shared/func/folder_check.dart';

class ReadingBooksScreen extends StatelessWidget {
  final List<Map<String, dynamic>> readingBooks;

  const ReadingBooksScreen({super.key, required this.readingBooks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الكتب قيد القراءة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Back.btn(context),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: readingBooks.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio:
                MediaQuery.of(context).size.width > 600 ? 0.7 : 0.62,
          ),
          itemBuilder: (context, index) {
            final book = readingBooks[index];
            final String bookName =
                (book['book_name'] ?? 'بدون عنوان').toString();
            final double currentPage = (book['scrollposition'] ?? 0).toDouble();
            final double pagesL = (book['pagesL'] ?? 1).toDouble();
            final double percent =
                pagesL > 0 ? (currentPage / pagesL).clamp(0.0, 1.0) : 0.0;
            final String percentText = '${(percent * 100).toStringAsFixed(0)}%';
            final String bookId = book['book_id'].toString();
            // Resolve image path lazily inside FutureBuilder to avoid async here
            final Future<String> imagePathFuture = (() async {
              final booksBase = await getBooksBaseDir();
              return p.join(booksBase.path, 'tmp', bookId, '$bookId.jpg');
            })();

            return ZoomTapAnimation(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ContentPage(
                      bookId: bookId,
                      bookName: bookName,
                      scrollPosetion: currentPage,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Background image
                      Positioned.fill(
                        child: FutureBuilder<String>(
                          future: imagePathFuture,
                          builder: (context, snap) {
                            final imgPath = snap.data;
                            if (imgPath != null && File(imgPath).existsSync()) {
                              return Image.file(
                                File(imgPath),
                                fit: BoxFit.cover,
                              ).animate().fadeIn(duration: 450.ms);
                            }
                            return Container(
                              color: theme.colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 64,
                                color: Colors.grey.shade500,
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.35),
                                Colors.black.withOpacity(0.65),
                              ],
                              stops: const [0.2, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Top row: chip + percent
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Expanded(
                              child: _infoChip(
                                context,
                                text: 'ID: $bookId',
                                background: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _infoChip(
                              context,
                              text: percentText,
                              background: Colors.black.withOpacity(0.35),
                            ),
                          ],
                        ),
                      ),

                      // Bottom content
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                height: 1.2,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearPercentIndicator(
                                isRTL: true,
                                lineHeight: 14,
                                percent: percent,
                                padding: EdgeInsets.zero,
                                center: Text(
                                  percentText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                progressColor: percent > 0.7
                                    ? Colors.greenAccent.shade400
                                    : Colors.amberAccent.shade400,
                                backgroundColor: Colors.white.withOpacity(0.25),
                                animation: true,
                                animationDuration: 800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      'تابع القراءة',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .moveY(begin: 18, end: 0, curve: Curves.easeOutCubic),
            );
          },
        ),
      ),
    );
  }
}

Widget _infoChip(BuildContext context,
    {required String text, Color? background}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: background ?? Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
    ),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
