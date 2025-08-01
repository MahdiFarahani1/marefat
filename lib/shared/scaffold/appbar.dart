import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/mainWrapper/view/navigaion.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppbar {
  static AppBar littleAppBar(BuildContext context,
      {required String title, Widget? actions}) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: customGradinet(context)),
      ).animate().fadeIn(duration: 500.ms).scale(
            duration: 500.ms,
            curve: Curves.easeOut,
          ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
      ),
      actions: [actions ?? SizedBox.shrink()],
    );
  }

  static AppBar show(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          children: [
            Builder(builder: (context) {
              return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Assets.icons.fiRrMenuBurger
                      .image(width: 20, height: 20, color: Colors.white));
            }),
            SizedBox(width: 6.5),
            Text(
              'المعرفة الدينية',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
      leadingWidth: 200,
      flexibleSpace: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                state.primry,
                state.unselected,
              ])));
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 4),
              InkWell(
                  onTap: () {
                    MainWrapper.controllerNavBar.jumpToTab(0);
                  },
                  child: Assets.images.logoAppbar
                      .image(width: 30, height: 30, color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }
}
