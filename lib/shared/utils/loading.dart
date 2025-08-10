import 'package:flutter/material.dart';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomLoading {
  static Widget pulse(BuildContext context) {
    return LoadingAnimationWidget.bouncingBall(
      color: Theme.of(context).primaryColor,
      size: 25,
    ).padAll(8);
  }

  static Widget loadLine(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Theme.of(context).primaryColor,
      size: 25,
    ).padAll(8);
  }

  static Widget fadingCircle(BuildContext context) {
    return LoadingAnimationWidget.threeArchedCircle(
      color: Theme.of(context).primaryColor,
      size: 30,
    ).padAll(8);
  }
}
