import 'package:bookapp/features/about/view/about_app_screen.dart';
import 'package:bookapp/features/mainWrapper/view/navigaion.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/features/settings/view/settings_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
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
                    color: Theme.of(context).colorScheme.tertiary,
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
                    final Uri url = Uri.parse(
                        'https://maarifadeen.com/privacy_policy_almaerifa.html');

                    launchUrl(url);
                  }),

                  EsaySize.gap(2), const Divider(),
                  // اشتراک‌گذاری
                  ListTile(
                    leading: Assets.newicons.paperPlaneTop.image(
                      width: 18,
                      height: 18,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    title: const Text('مشاركة التطبيق'),
                    trailing: Assets.icons.fiRrAngleLeft.image(
                      width: 12,
                      height: 12,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    onTap: () {
                      Share.share(
                          'https://play.google.com/store/apps/details?id=com.dijlah.almarifaaldenyah');
                    },
                  ),

                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return ListTile(
                          leading: Assets.newicons.moon.image(
                            width: 18,
                            height: 18,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          title: const Text('الوضع الليلي'),
                          trailing: Transform.scale(
                              scale: 0.77,
                              child: Switch(
                                activeColor: Colors.black,
                                inactiveTrackColor:
                                    Theme.of(context).primaryColor,
                                inactiveThumbColor: Colors.white,
                                activeTrackColor: Colors.grey.shade800,
                                value: state.darkMode,
                                onChanged: (value) {
                                  context
                                      .read<SettingsCubit>()
                                      .updateDarkMode(value);
                                },
                              )));
                    },
                  ),
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

  Widget _buildDrawerItem(
    String pathIcon,
    String title,
    Function ontab,
  ) {
    return Builder(builder: (context) {
      return ListTile(
        leading: Image.asset(
          pathIcon,
          width: 18,
          height: 18,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Assets.icons.fiRrAngleLeft.image(
          width: 12,
          height: 12,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        onTap: () {
          ontab();
        },
      );
    });
  }
}
