import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/articles/view/articles_screen.dart';
import 'package:bookapp/features/mainWrapper/view/home_Page.dart';
import 'package:bookapp/features/mainWrapper/bloc/navigation_cubit.dart';
import 'package:bookapp/features/photo_gallery/view/photo_gallery_page.dart';
import 'package:bookapp/features/questions/view/questions_category_screen.dart';
import 'package:bookapp/features/storage/view/storage_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:bookapp/shared/scaffold/draver.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainWrapper extends StatelessWidget {
  static final controllerNavBar = PersistentTabController();
  const MainWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(onThemeToggle: (p0) {}, isDarkMode: true),
      appBar: CustomAppbar.show(context),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return PersistentTabView(
            controller: controllerNavBar,
            onTabChanged: (value) {
              BlocProvider.of<NavigationCubit>(context).setPage(value);
            },
            tabs: [
              navItem(
                  widthIcon: 20,
                  heightIcon: 20,
                  itemColor:
                      state == 0 ? AppColors.textLight : AppColors.unselected,
                  iconPath: Assets.icons.fiRrBookAlt.path,
                  title: 'المكتبة',
                  screen: HomePage()),
              navItem(
                  widthIcon: 20,
                  heightIcon: 20,
                  itemColor:
                      state == 1 ? AppColors.textLight : AppColors.unselected,
                  iconPath: Assets.icons.fiRrDuplicate.path,
                  title: 'المقالات',
                  screen: ArticlesScreen()),
              navItem(
                  itemColor:
                      state == 2 ? AppColors.textLight : AppColors.unselected,
                  iconPath: Assets.icons.question.path,
                  widthIcon: 22,
                  heightIcon: 22,
                  title: 'الاسئلة',
                  screen: QuestionsScreen()),
              navItem(
                  widthIcon: 20,
                  heightIcon: 20,
                  itemColor:
                      state == 3 ? AppColors.textLight : AppColors.unselected,
                  iconPath: Assets.icons.fiRrGallery.path,
                  title: 'الصور',
                  screen: PhotoGalleryPage()),
              navItem(
                  widthIcon: 20,
                  heightIcon: 20,
                  itemColor:
                      state == 4 ? AppColors.textLight : AppColors.unselected,
                  iconPath: Assets.icons.fiRrBookmark.path,
                  title: 'المفضلة',
                  screen: StorageScreen()),
            ],
            navBarBuilder: (navBarConfig) => Style6BottomNavBar(
                navBarConfig: navBarConfig,
                navBarDecoration: NavBarDecoration(
                  padding: EdgeInsets.all(9),
                  gradient: customGradinet(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                itemAnimationProperties: ItemAnimation(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                )),
          );
        },
      ),
    );
  }

  PersistentTabConfig navItem(
      {required String iconPath,
      required String title,
      required Widget screen,
      required Color itemColor,
      double? widthIcon,
      double? heightIcon}) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Image.asset(
              iconPath,
              width: widthIcon ?? 16,
              height: heightIcon ?? 16,
              color: itemColor,
            ),
          ),
          iconSize: 22,
          title: title,
          activeForegroundColor: AppColors.textLight,
          textStyle: TextStyle(fontSize: 11)),
    );
  }
}
