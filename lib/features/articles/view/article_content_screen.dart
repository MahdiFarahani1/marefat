import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = context.read<SettingsCubit>().state.primry;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Assets.newicons.paperPlaneTop
            .image(color: Colors.white, width: 24, height: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back.btn(context),
        actions: [
          IconButton(
            onPressed: () {
              AppDialog.showInfoDialog(
                  context, 'المعلومات', article.summary ?? "غير موجود");
            },
            icon: Assets.newicons.termsInfo.image(
                width: 25, height: 25, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان مقاله
              Text(
                article.title ?? '',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.4),

              const SizedBox(height: 16),

              // خط جداکننده ظریف
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 16),

              // محتوای مقاله
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: HtmlWidget(
                    article.content ?? '',
                    textStyle: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.75,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.95, 0.95)),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
