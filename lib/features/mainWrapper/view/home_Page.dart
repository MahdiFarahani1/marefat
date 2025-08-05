import 'dart:io';

import 'package:bookapp/features/books/view/books_downloaded.dart';
import 'package:bookapp/features/books/view/books_screen.dart';
import 'package:bookapp/features/mainWrapper/bloc/slider/slider_cubit.dart';
import 'package:bookapp/features/mainWrapper/view/all_lastBook.dart';
import 'package:bookapp/features/mainWrapper/widget/bookitem.dart';
import 'package:bookapp/features/mainWrapper/widget/empty_reading.dart';
import 'package:bookapp/features/reading_progress/bloc/cubit/readingbook_cubit.dart';
import 'package:bookapp/features/search/view/search_screen.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sliderImages = [
    Assets.images.b1.path,
    Assets.images.b2.path,
    Assets.images.b3.path,
  ];

  final List<Color> featureColors = [
    Colors.red,
    Colors.amber,
    Colors.purple,
    Colors.cyanAccent,
    Colors.deepOrange,
    Colors.brown,
  ];

  final List<FeatureModel> features = [
    FeatureModel(icon: Assets.images.downloadedbook.path, label: 'مطالعة'),
    FeatureModel(icon: Assets.images.downloadBook.path, label: 'تحميل'),
    FeatureModel(icon: Assets.images.bookmark.path, label: 'اشارات'),
    FeatureModel(icon: Assets.images.comment.path, label: 'تعليقات'),
    FeatureModel(icon: Assets.images.questionPng.path, label: 'اسأل'),
    FeatureModel(icon: Assets.images.share.path, label: 'انشر'),
  ];

  void _onFeatureTap(int index) {
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
        LaunchUrl.launchEmail(LaunchUrl.email);
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
      backgroundColor: Colors.grey[100],
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          Assets.newicons.search.image(
                              width: 20,
                              height: 20,
                              color: Theme.of(context).primaryColor),
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
                        return const SizedBox(
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state.statusSlider is SliderLoaded) {
                        final sliders =
                            (state.statusSlider as SliderLoaded).sliders;

                        return Column(
                          children: [
                            SizedBox(
                              height: 160,
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 160,
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.9,
                                  onPageChanged: (index, reason) {
                                    context
                                        .read<SliderCubit>()
                                        .indicatorChanged(index);
                                  },
                                ),
                                items: sliders.map((slider) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
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
                                  duration: Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  width: state.currentIndex == index ? 10 : 6,
                                  height: state.currentIndex == index ? 10 : 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state.currentIndex == index
                                        ? context
                                            .read<SettingsCubit>()
                                            .state
                                            .primry
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
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
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: features.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2,
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 4,
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
                  ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
                  const SizedBox(height: 20.0),

                  BlocBuilder<SliderCubit, SliderState>(
                    builder: (context, state) {
                      if (state.statusSlider is SliderLoading) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state.statusSlider is SliderLoaded) {
                        final books =
                            (state.statusSlider as SliderLoaded).books;
                        // 📖 Book Lists
                        return Column(
                          children: [
                            SectionHeader(
                                    title: 'الكتب الأكثر شهرة',
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
                                  return BookCard(
                                    imageUrl: books[index].photoUrl,
                                    title: books[index].title,
                                    author: books[index].writer ?? '',
                                  )
                                      .animate(delay: (150 * index).ms)
                                      .fadeIn(duration: 700.ms)
                                      .slideX(begin: 0.5)
                                      .scale(begin: Offset(0.8, 0.8));
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
                                                AllLastBooks()),
                                      );
                                    })
                                .animate(delay: 800.ms)
                                .fadeIn(duration: 700.ms)
                                .slideX(begin: -0.3),
                            const SizedBox(height: 15.0),
                            SizedBox(
                              height: 280,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: state.books.length,
                                itemBuilder: (context, index) {
                                  final book = state.books[index];
                                  final double current = book['scrollposition'];
                                  final int total = book['pagesL'];

                                  final double percent =
                                      total > 0 ? current / total : 0;

                                  final String percentText =
                                      '${(percent * 100).toStringAsFixed(0)}%';

                                  final String bookId =
                                      book['book_id'].toString();
                                  final String imagePath =
                                      '/storage/emulated/0/Download/Books/tmp/$bookId/$bookId.jpg';

                                  return Container(
                                    width: 145,
                                    margin: const EdgeInsets.only(right: 15.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.12),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<bool>(
                                          future: File(imagePath).exists(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const SizedBox(
                                                width: 100,
                                                height: 140,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            } else if (snapshot.hasData &&
                                                snapshot.data == true) {
                                              return Container(
                                                width: 150,
                                                height: 180,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: Image.file(
                                                  File(imagePath),
                                                  fit: BoxFit.cover,
                                                )
                                                    .animate()
                                                    .fadeIn(duration: 500.ms)
                                                    .scale(
                                                        begin: const Offset(
                                                            0.95, 0.95))
                                                    .shimmer(
                                                        duration: 1000.ms,
                                                        delay: 300.ms),
                                              );
                                            } else {
                                              return Container(
                                                width: 100,
                                                height: 140,
                                                color: Colors.grey.shade300,
                                                child: const Center(
                                                    child: Icon(Icons
                                                        .image_not_supported)),
                                              )
                                                  .animate()
                                                  .fadeIn(duration: 600.ms)
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
                                            color: Color(0xFF333333),
                                          ),
                                        )
                                            .animate()
                                            .fadeIn(
                                                duration: 500.ms, delay: 300.ms)
                                            .slideY(begin: 0.3),
                                        const SizedBox(height: 4.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'موقع: ${current.toStringAsFixed(0)}',
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
                                              percent: percent.clamp(0.0, 1.0),
                                              center: Text(
                                                percentText,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              progressColor: Colors.green,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              animation: true,
                                              animationDuration: 800,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.3),
              Theme.of(context).primaryColor.withOpacity(0.1)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              model.icon,
              width: 30,
              height: 30,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: Offset(0.5, 0.5))
                .shimmer(duration: 1000.ms),
            const SizedBox(height: 8),
            Text(
              model.label,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 13),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.5)
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
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
