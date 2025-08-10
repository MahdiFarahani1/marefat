import 'package:bookapp/features/mainWrapper/view/navigaion.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppbar {
  static AppBar littleAppBar(BuildContext context,
      {required String title, Widget? actions}) {
    return AppBar(
      flexibleSpace: Container().animate().fadeIn(duration: 500.ms).scale(
            duration: 500.ms,
            curve: Curves.easeOut,
          ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
      ),
      centerTitle: true,
      leading: Back.btn(context),
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
                  child: Assets.newicons.barsStaggered.image(
                      width: 20,
                      height: 20,
                      color: Theme.of(context).primaryColor));
            }),
            SizedBox(width: 6.5),
            Text(
              'المعرفة الدينية',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      leadingWidth: 200,
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
                  child: Assets.images.logoAppbar.image(
                      width: 30,
                      height: 30,
                      color: Theme.of(context).primaryColor))
            ],
          ),
        ),
      ],
    );
  }
}
