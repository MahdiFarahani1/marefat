import 'package:bookapp/config/splash/splash.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<_OnboardItem> pages = [
    _OnboardItem(
      title: 'المعرفة الدينية',
      description:
          'يهتم بتبيين المعرفة الدينية على وجه ميسر وبلغة واضحة، لتسهيل الوصول إليها لكل باحث عن الحقيقة وساع إليها.',
      image: Assets.images.inSp1.path,
    ),
    _OnboardItem(
      title: 'كتب ومؤلفات',
      description:
          'مجموعة من الكتب العقائدية والفكرية للسيد محمد باقر السيستاني حفظه الله',
      image: Assets.images.inSp2.path,
    ),
    _OnboardItem(
      title: 'أسئلة وأجوبة',
      description: 'أسئلة وأجوبة متنوعة ترتبط بالمعرفة الدينية',
      image: Assets.images.inSp3.path,
    ),
  ];

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: EsaySize.width(context),
        height: EsaySize.height(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.images.bgSp.path), fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemCount: pages.length,
                itemBuilder: (_, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        SizedBox(height: EsaySize.height(context) * 0.15),
                        Image.asset(page.image, height: 260)
                            .animate()
                            .fade(duration: 800.ms)
                            .slideY(begin: 0.3),
                        const SizedBox(height: 32),
                        Text(page.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.black))
                            .animate()
                            .fade()
                            .slideY(begin: 0.5, delay: 200.ms),
                        const SizedBox(height: 16),
                        Text(page.description,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ))
                            .animate()
                            .fade()
                            .slideY(begin: 0.5, delay: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator + Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? theme.colorScheme.primary
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      currentPage == pages.length - 1 ? 'ابدأ' : 'التالي',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardItem {
  final String title;
  final String description;
  final String image;

  _OnboardItem({
    required this.title,
    required this.description,
    required this.image,
  });
}
