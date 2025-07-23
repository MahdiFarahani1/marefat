import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

LinearGradient customGradinet(BuildContext context) {
  return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        context.read<SettingsCubit>().state.primry,
        context.read<SettingsCubit>().state.unselected,
      ]);
}
