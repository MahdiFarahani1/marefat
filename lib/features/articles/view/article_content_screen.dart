import 'package:bookapp/features/articles/bloc/cubit/article_cubit_cubit.dart';
import 'package:bookapp/features/articles/bloc/fontsize/cubit/article_cubit.dart';
import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/back_btn.dart';
import 'package:bookapp/shared/ui_helper/dialog_common.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
        onPressed: () {
          Share.share('${article.title}\n${article.content}');
        },
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
              const SizedBox(height: 8),

              Row(
                children: [
                  Builder(builder: (context) {
                    return ZoomTapAnimation(
                        onTap: () =>
                            context.read<ArticleFontSizeCubit>().plusFontSize(),
                        child: Assets.newicons.squarePlus.image(
                            width: 35,
                            height: 35,
                            color: Theme.of(context).primaryColor));
                  }),
                  EsaySize.gap(6),
                  ZoomTapAnimation(
                      onTap: () =>
                          context.read<ArticleFontSizeCubit>().minusFontSize(),
                      child: Assets.newicons.squareMinus.image(
                          width: 35,
                          height: 35,
                          color: Theme.of(context).primaryColor))
                ],
              ).animate().fadeIn(duration: 600.ms),

              const SizedBox(height: 8),

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
                        child: BlocBuilder<ArticleFontSizeCubit, double>(
                          builder: (context, state) {
                            return Html(
                              data: article.content ?? '',
                              style: {
                                "*": Style(
                                  fontSize: FontSize(state),
                                  lineHeight: const LineHeight(1.75),
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              },
                            );
                          },
                        ))
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
