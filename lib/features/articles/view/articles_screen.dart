import 'package:bookapp/features/articles/bloc/cubit/article_cubit_cubit.dart';
import 'package:bookapp/features/articles/model/artile_model.dart';
import 'package:bookapp/features/articles/view/article_content_screen.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  void initState() {
    BlocProvider.of<ArticleCubit>(context).fetchArticle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<ArticleCubit, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return Center(child: CustomLoading.fadingCircle(context));
          } else if (state is ArticleError) {
            return ApiErrorWidget(
              onRetry: () async {
                await BlocProvider.of<ArticleCubit>(context).fetchArticle();
              },
            );
          } else if (state is ArticleLoaded) {
            final List<ArticleModel> data = state.articles;

            return RefreshIndicator(
              onRefresh: () async {
                await BlocProvider.of<ArticleCubit>(context).fetchArticle();
              },
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  // Optional title

                  const SizedBox(height: 16),

                  // Article list
                  ...data.map((article) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                width: 43,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  gradient: customGradinet(context),
                                ),
                                child: Center(
                                    child: Assets.icons.newspaper1
                                        .image(color: Colors.white)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? '',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (article.summary != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          article.summary!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    size: 18),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                    );
                  }),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
