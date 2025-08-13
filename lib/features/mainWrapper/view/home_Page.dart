import 'dart:io';

import 'package:bookapp/features/books/view/books_downloaded.dart';
import 'package:bookapp/features/books/view/books_screen.dart';
import 'package:bookapp/features/mainWrapper/bloc/slider/slider_cubit.dart';
import 'package:bookapp/features/mainWrapper/view/all_lastBook.dart';
import 'package:bookapp/features/mainWrapper/view/all_readingbook.dart';
import 'package:bookapp/features/mainWrapper/widget/bookitem.dart';
import 'package:bookapp/features/mainWrapper/widget/empty_reading.dart';
import 'package:bookapp/features/reading_progress/bloc/cubit/readingbook_cubit.dart';
import 'package:bookapp/features/search/view/search_screen.dart';
import 'package:bookapp/features/storage/view/storage_comment_screen.dart';
import 'package:bookapp/features/storage/view/storage_page_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/func/launchURL.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:path/path.dart' as p;
import 'package:bookapp/shared/func/folder_check.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FeatureModel> features = [
    FeatureModel(icon: Assets.images.downloadedbook.path, label: 'مطالعة'),
    FeatureModel(icon: Assets.images.downloadBook.path, label: 'تحميل'),
    FeatureModel(icon: Assets.images.bookmark.path, label: 'اشارات'),
    FeatureModel(icon: Assets.images.comment.path, label: 'تعليقات'),
    FeatureModel(icon: Assets.images.questionPng.path, label: 'اسأل'),
    FeatureModel(icon: Assets.images.share.path, label: 'انشر'),
  ];

  void _onFeatureTap(int index) async {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => DownloadedBooksPage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BooksScreen()));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StoragePageScreen(
                      isBack: true,
                    )));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CommentScreen(
                      isBack: true,
                    )));
        break;
      case 4:
        await LaunchUrl.launchEmail();
        break;
      case 5:
        Share.share(
            'https://play.google.com/store/apps/details?id=com.dijlah.almarifaaldenyah');
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SliderCubit>().loadHomeApi();
    context.read<ReadingbookCubit>().getReadingDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<SliderCubit>().loadHomeApi();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: BlocBuilder<ReadingbookCubit, ReadingbookState>(
            builder: (context, readingState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          Assets.newicons.search
                              .image(width: 20, height: 20, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            'ابحث عن كتاب أو مؤلف...',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2, end: 0),
                  const SizedBox(height: 15.0),

                  // 🖼️ Image Slider
                  BlocBuilder<SliderCubit, SliderState>(
                    builder: (context, state) {
                      if (state.statusSlider is SliderLoading) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                              child: CustomLoading.fadingCircle(context)),
                        );
                      } else if (state.statusSlider is SliderLoaded) {
                        final sliders =
                            (state.statusSlider as SliderLoaded).sliders;
                        return Column(
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              double sliderHeight = 160;
                              double viewportFraction = 0.9;
                              double borderRadius = 15;
                              double indicatorSize = 6;
                              double indicatorSpacing = 4;

                              if (width >= 1200) {
                                // دسکتاپ
                                sliderHeight = 280;
                                viewportFraction = 0.7;
                                borderRadius = 20;
                                indicatorSize = 10;
                                indicatorSpacing = 6;
                              } else if (width >= 800) {
                                // تبلت
                                sliderHeight = 220;
                                viewportFraction = 0.8;
                                borderRadius = 18;
                                indicatorSize = 8;
                                indicatorSpacing = 5;
                              }

                              return Column(
                                children: [
                                  SizedBox(
                                    height: sliderHeight,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: sliderHeight,
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        viewportFraction: viewportFraction,
                                        onPageChanged: (index, reason) {
                                          context
                                              .read<SliderCubit>()
                                              .indicatorChanged(index);
                                        },
                                      ),
                                      items: sliders.map((slider) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          child: Image.network(
                                            slider.photoUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        )
                                            .animate()
                                            .fadeIn(duration: 800.ms)
                                            .scale(begin: Offset(0.8, 0.8));
                                      }).toList(),
                                    )
                                        .animate()
                                        .fadeIn(duration: 700.ms, delay: 200.ms)
                                        .slideX(begin: 0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      sliders.length,
                                      (index) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: indicatorSpacing),
                                        width: state.currentIndex == index
                                            ? indicatorSize
                                            : indicatorSize - 2,
                                        height: state.currentIndex == index
                                            ? indicatorSize
                                            : indicatorSize - 2,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: state.currentIndex == index
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        );
                      } else if (state.currentIndex is SliderError) {
                        return Text('!!!!!!!!!!');
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),

                  const SizedBox(height: 20.0),

                  // 📚 Feature Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      // تعیین تعداد ستون بر اساس عرض
                      int crossAxisCount;
                      double childAspectRatio;

                      if (width >= 1200) {
                        crossAxisCount = 5;
                        childAspectRatio = 1.3;
                      } else if (width >= 800) {
                        crossAxisCount = 4;
                        childAspectRatio = 1.2;
                      } else if (width >= 600) {
                        crossAxisCount = 3;
                        childAspectRatio = 1.0;
                      } else {
                        crossAxisCount = 3;
                        childAspectRatio = 0.9;
                      }

                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: features.length,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return FeatureItem(
                            model: features[index],
                            onTap: () => _onFeatureTap(index),
                          )
                              .animate(delay: (100 * index).ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.3)
                              .scale(begin: Offset(0.8, 0.8));
                        },
                      ).animate(delay: 400.ms).fadeIn(duration: 800.ms);
                    },
                  ),

                  const SizedBox(height: 20.0),

                  BlocBuilder<SliderCubit, SliderState>(
                    builder: (context, state) {
                      if (state.statusSlider is SliderLoading) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                              child: CustomLoading.fadingCircle(context)),
                        );
                      } else if (state.statusSlider is SliderLoaded) {
                        final books =
                            (state.statusSlider as SliderLoaded).books;
                        // 📖 Book Lists
                        return Column(
                          children: [
                            SectionHeader(
                                    title: 'أحدث الكتب',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllLastBooks()),
                                      );
                                    })
                                .animate(delay: 600.ms)
                                .fadeIn(duration: 700.ms)
                                .slideX(begin: -0.3),
                            const SizedBox(height: 15.0),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return ZoomTapAnimation(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllLastBooks()),
                                      );
                                    },
                                    child: BookCard(
                                      imageUrl: books[index].photoUrl,
                                      title: books[index].title,
                                      author: books[index].writer ?? '',
                                    )
                                        .animate(delay: (150 * index).ms)
                                        .fadeIn(duration: 700.ms)
                                        .slideX(begin: 0.5)
                                        .scale(begin: Offset(0.8, 0.8)),
                                  );
                                },
                              ),
                            )
                                .animate(delay: 700.ms)
                                .fadeIn(duration: 800.ms)
                                .slideX(begin: 0.5)
                          ],
                        );
                      } else if (state.statusSlider is SliderError) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: Text('خطأ في تحميل الكتب')),
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  BlocBuilder<ReadingbookCubit, ReadingbookState>(
                    builder: (context, state) {
                      if (state.status == ReadingbookStatus.loading) {
                        return Center(
                          child: CustomLoading.fadingCircle(context),
                        );
                      }

                      if (state.status == ReadingbookStatus.error) {
                        return const Center(
                          child: Text('خطأ في تحميل الكتب'),
                        );
                      }

                      if (state.books.isEmpty) {
                        return const Center(
                          child: EmptyProgressBox(),
                        );
                      }
                      if (state.status == ReadingbookStatus.success) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                                    title: 'الكتب الأحدث',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReadingBooksScreen(
                                                  readingBooks: state.books,
                                                )),
                                      );
                                    })
                                .animate(delay: 800.ms)
                                .fadeIn(duration: 700.ms)
                                .slideX(begin: -0.3),
                            const SizedBox(height: 15.0),
                            SizedBox(
                              height: 280,
                              child: FutureBuilder<Directory>(
                                future: getBooksBaseDir(),
                                builder: (context, baseSnap) {
                                  if (!baseSnap.hasData) {
                                    return const SizedBox();
                                  }
                                  final baseDir = baseSnap.data!;
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: state.books.length,
                                    itemBuilder: (context, index) {
                                      final book = state.books[index];
                                      final double current =
                                          book['scrollposition'];
                                      final int total = book['pagesL'];

                                      final double percent =
                                          total > 0 ? current / total : 0;

                                      final String percentText =
                                          '${(percent * 100).toStringAsFixed(0)}%';

                                      final String bookId =
                                          book['book_id'].toString();
                                      final String imagePath = p.join(
                                          baseDir.path,
                                          'tmp',
                                          bookId,
                                          '$bookId.jpg');

                                      return ZoomTapAnimation(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReadingBooksScreen(
                                                      readingBooks: state.books,
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          width: 145,
                                          margin: const EdgeInsets.only(
                                              right: 15.0),
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<bool>(
                                                future:
                                                    File(imagePath).exists(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return SizedBox(
                                                      width: 100,
                                                      height: 140,
                                                      child: Center(
                                                          child: CustomLoading
                                                              .fadingCircle(
                                                                  context)),
                                                    );
                                                  } else if (snapshot.hasData &&
                                                      snapshot.data == true) {
                                                    return Container(
                                                      width: 150,
                                                      height: 180,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 8,
                                                            offset:
                                                                const Offset(
                                                                    0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: Image.file(
                                                        File(imagePath),
                                                        fit: BoxFit.cover,
                                                      )
                                                          .animate()
                                                          .fadeIn(
                                                              duration: 500.ms)
                                                          .scale(
                                                              begin:
                                                                  const Offset(
                                                                      0.95,
                                                                      0.95))
                                                          .shimmer(
                                                              duration: 1000.ms,
                                                              delay: 300.ms),
                                                    );
                                                  } else {
                                                    return Container(
                                                      width: 100,
                                                      height: 140,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Center(
                                                          child: Icon(Icons
                                                              .image_not_supported)),
                                                    )
                                                        .animate()
                                                        .fadeIn(
                                                            duration: 600.ms)
                                                        .scale(
                                                            begin: const Offset(
                                                                0.9, 0.9))
                                                        .shimmer(
                                                            duration: 1200.ms,
                                                            delay: 400.ms);
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(
                                                book['book_name'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              )
                                                  .animate()
                                                  .fadeIn(
                                                      duration: 500.ms,
                                                      delay: 300.ms)
                                                  .slideY(begin: 0.3),
                                              const SizedBox(height: 4.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'الصفحة: ${current.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                      .animate()
                                                      .fadeIn(
                                                          duration: 500.ms,
                                                          delay: 400.ms)
                                                      .slideY(begin: 0.3),
                                                  CircularPercentIndicator(
                                                    radius: 22.0,
                                                    lineWidth: 4.5,
                                                    percent:
                                                        percent.clamp(0.0, 1.0),
                                                    center: Text(
                                                      percentText,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    progressColor: percent > 0.7
                                                        ? Colors.greenAccent
                                                            .shade400
                                                        : Colors.amberAccent
                                                            .shade400,
                                                    backgroundColor:
                                                        Colors.grey.shade300,
                                                    animation: true,
                                                    animationDuration: 800,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return SizedBox();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FeatureModel {
  final String icon;
  final String label;

  const FeatureModel({required this.icon, required this.label});
}

class FeatureItem extends StatelessWidget {
  final FeatureModel model;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    double iconSize = 34;
    double fontSize = 13;
    double spacing = 8;

    if (width >= 1200) {
      // دسکتاپ
      iconSize = 50;
      fontSize = 16;
      spacing = 12;
    } else if (width >= 800) {
      // تبلت
      iconSize = 40;
      fontSize = 14;
      spacing = 10;
    }

    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              model.icon,
              width: iconSize,
              height: iconSize,
              color: Theme.of(context).colorScheme.tertiary,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: Offset(0.5, 0.5))
                .shimmer(duration: 1000.ms),
            SizedBox(height: spacing),
            Text(
              model.label,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: fontSize),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.5),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const SectionHeader(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
        TextButton(
          onPressed: () {
            onPressed();
          },
          child: const Text(
            'عرض الكل',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: 0.3),
        ),
      ],
    );
  }
}
