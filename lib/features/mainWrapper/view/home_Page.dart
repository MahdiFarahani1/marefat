import 'package:bookapp/features/books/view/books_downloaded.dart';
import 'package:bookapp/features/books/view/books_screen.dart';
import 'package:bookapp/features/mainWrapper/bloc/slider/slider_cubit.dart';
import 'package:bookapp/features/search/view/search_screen.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/storage/view/storage_comment_screen.dart';
import 'package:bookapp/features/storage/view/storage_page_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/func/launchURL.dart';
import 'package:bookapp/shared/utils/images_network.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'مطالعة'),
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'تحميل'),
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'اشارات'),
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'تعليقات'),
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'اسأل'),
    FeatureModel(icon: Assets.icons.fiRrBook.path, label: 'انشر'),
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
    context.read<SliderCubit>().loadSliders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      'ابحث عن كتاب أو مؤلف...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
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
                  final sliders = (state.statusSlider as SliderLoaded).sliders;

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
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: state.currentIndex == index ? 10 : 6,
                            height: state.currentIndex == index ? 10 : 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: state.currentIndex == index
                                  ? context.read<SettingsCubit>().state.primry
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
                  color: featureColors[index % featureColors.length],
                  onTap: () => _onFeatureTap(index),
                )
                    .animate(delay: (100 * index).ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3)
                    .scale(begin: Offset(0.8, 0.8));
              },
            ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
            const SizedBox(height: 20.0),

            // 📖 Book Lists
            const SectionHeader(title: 'الكتب الأكثر شهرة')
                .animate(delay: 600.ms)
                .fadeIn(duration: 700.ms)
                .slideX(begin: -0.3),
            const SizedBox(height: 15.0),
            BookList(
              title: 'الثقافة الصغيرة',
              author: 'علي محمد أفغاني',
            )
                .animate(delay: 700.ms)
                .fadeIn(duration: 800.ms)
                .slideX(begin: 0.5),

            const SectionHeader(title: 'الكتب الأحدث')
                .animate(delay: 800.ms)
                .fadeIn(duration: 700.ms)
                .slideX(begin: -0.3),
            const SizedBox(height: 15.0),
            BookList(
              title: 'الخريف في السماء',
              author: 'زهرة رضوي',
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 800.ms)
                .slideX(begin: 0.5),
          ],
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
  final Color color;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.model,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
              color: Colors.white,
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: Offset(0.5, 0.5))
                .shimmer(duration: 1000.ms),
            const SizedBox(height: 8),
            Text(
              model.label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
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

  const SectionHeader({super.key, required this.title});

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
        const Text(
          'عرض الكل',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: 0.3),
      ],
    );
  }
}

class BookList extends StatelessWidget {
  final String title;
  final String author;

  const BookList({
    super.key,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return BookCard(
            imagePath:
                'https://maarifadeen.com/upload_list/source/Library/cov/377.jpg',
            title: title,
            author: author,
          )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 700.ms)
              .slideX(begin: 0.5)
              .scale(begin: Offset(0.8, 0.8));
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;

  const BookCard({
    required this.imagePath,
    required this.title,
    required this.author,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: ImageNetworkCommon(imageurl: imagePath),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: Offset(0.8, 0.8))
              .shimmer(duration: 1200.ms, delay: 400.ms),
          const SizedBox(height: 8.0),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 300.ms)
              .slideY(begin: 0.3),
          const SizedBox(height: 4.0),
          Text(
            author,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(begin: 0.3),
        ],
      ),
    );
  }
}
