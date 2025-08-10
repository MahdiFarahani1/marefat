import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class Back {
  static Widget btn(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(46),
        onTap: () {
          Navigator.pop(context);
        },
        child: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
          child: Assets.newicons.angleSmallRight.image(
              width: 20,
              height: 20,
              color: Theme.of(context).colorScheme.tertiary),
        )).padAll(9);
  }
}
