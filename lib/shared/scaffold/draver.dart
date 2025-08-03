import 'package:bookapp/features/about/view/about_app_screen.dart';
import 'package:bookapp/features/about/view/privacy_policy_screen.dart';
import 'package:bookapp/features/mainWrapper/view/navigaion.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:bookapp/config/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';

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
                      Assets.newicons.houseChimney.path, 'الرئيسية', () {
                    Navigator.pop(context);
                    MainWrapper.controllerNavBar.jumpToTab(0);
                  }),

                  _buildDrawerItem(
                      Assets.newicons.commentInfo.path, 'حول التطبيق', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutAppScreen(),
                        ));
                  }),
                  _buildDrawerItem(Assets.newicons.customize.path, 'الاعدادات',
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  }),
                  _buildDrawerItem(
                      Assets.newicons.userLock.path, 'سياسية الخصوصية', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ));
                  }),

                  EsaySize.gap(2), const Divider(),
                  // اشتراک‌گذاری
                  ListTile(
                    leading: Assets.newicons.paperPlaneTop
                        .image(width: 18, height: 18, color: Colors.black),
                    title: const Text('مشاركة التطبيق'),
                    trailing: Assets.icons.fiRrAngleLeft
                        .image(width: 12, height: 12, color: Colors.black),
                    onTap: () {
                      Share.share(
                          'https://play.google.com/store/apps/details?id=com.dijlah.almarifaaldenyah');
                    },
                  ),

                  ListTile(
                      leading: Assets.newicons.moon
                          .image(width: 18, height: 18, color: Colors.black),
                      title: const Text('الوضع الليلي'),
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
