import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
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

    return Scaffold(
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Assets.icons.send
                .image(color: Colors.white, width: 25, height: 25),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () {
                  AppDialog.showInfoDialog(
                      context, 'اطلاعات', article.summary ?? 'موجود نیست');
                },
                child: Assets.icons.infoduble
                    .image(color: Colors.white, width: 30, height: 30),
              ),
            ),
          ],
          flexibleSpace: Container(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Text(
                  article.title ?? '',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.read<SettingsCubit>().state.primry,
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),

                const SizedBox(height: 20),

                // Card content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        // Content
                        HtmlWidget(
                          article.content!,
                          textStyle: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale(begin: const Offset(0.97, 0.97)),
                ),
              ],
            ),
          ),
        ));
  }
}
