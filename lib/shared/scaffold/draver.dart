import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/config/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const CustomDrawer({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundLight,
      child: SizedBox(
        height: EsaySize.height(context),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    Assets.images.logoHeader.path,
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(height: 8),

                  const Divider(height: 32),
                  _buildDrawerItem(
                      Assets.icons.fiRrHome.path, 'الرئيسية', () {}),
                  _buildDrawerItem(Assets.icons.fiRrPresentation.path,
                      'السيرة ذاتية', () {}),
                  _buildDrawerItem(
                      Assets.icons.fiRrCommentInfo.path, 'حول التطبيق', () {}),
                  _buildDrawerItem(Assets.icons.fiRrSettings.path, 'الاعدادات',
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  }),
                  _buildDrawerItem(
                      Assets.icons.fiRrBook.path, 'سياسية الخصوصية', () {}),
                  _buildDrawerItem(Assets.icons.fiRrStar.path,
                      'المفضلة والاشارات المرجعية', () {}),
                  EsaySize.gap(2), const Divider(),
                  // اشتراک‌گذاری
                  ListTile(
                    leading: Assets.icons.send
                        .image(width: 18, height: 18, color: Colors.black),
                    title: const Text('مشاركة التطبيق'),
                    trailing: Assets.icons.fiRrAngleLeft
                        .image(width: 12, height: 12, color: Colors.black),
                    onTap: () {},
                  ),

                  ListTile(
                      leading: Assets.icons.fiRrMoon
                          .image(width: 18, height: 18, color: Colors.black),
                      title: const Text('مشاركة التطبيق'),
                      trailing: Transform.scale(
                          scale: 0.77,
                          child: Switch(
                              value: isDarkMode, onChanged: onThemeToggle))),
                  // سوییچ حالت شب

                  const SizedBox(height: 12),

                  // فوتر
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Text('الاصدار: 1.0.0', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    'Powered by Dlijah IT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black54,
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

  Widget _buildDrawerItem(String pathIcon, String title, Function ontab) {
    return ListTile(
      leading: Image.asset(
        pathIcon,
        width: 18,
        height: 18,
        color: Colors.black,
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Assets.icons.fiRrAngleLeft
          .image(width: 12, height: 12, color: Colors.black),
      onTap: () {
        ontab();
      },
    );
  }
}
