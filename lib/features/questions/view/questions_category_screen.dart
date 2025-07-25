import 'package:animated_stack/animated_stack.dart';
import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/questions/bloc/questionItems/question_cubit.dart';
import 'package:bookapp/features/questions/bloc/questionItems/status_question.dart';
import 'package:bookapp/features/questions/view/search_question.dart';
import 'package:bookapp/features/questions/widgets/item_question.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/error_widget.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bookapp/features/questions/models/question_category_model.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<QuestionCubit>(context).initalCategoryFetch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        final status = state.status;

        return Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedStack(
            enableClickToDismiss: true,
            preventForegroundInteractions: true,
            backgroundColor: context.read<SettingsCubit>().state.unselected,
            animateButton: true,
            fabBackgroundColor: context.read<SettingsCubit>().state.unselected,
            fabIconColor: Colors.white,
            columnWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItem(
                  onTap: () {
                    print('dsdfasdas');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchQuestionPage(),
                        ));
                  },
                  iconPath: Assets.icons.fiRrSearch.path,
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  onTap: () {},
                  iconPath: Assets.icons.send.path,
                ),
                const SizedBox(height: 16),
                _buildMenuItem(
                  onTap: () {},
                  iconPath: Assets.icons.question.path,
                ),
              ],
            ),
            bottomWidget: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: EsaySize.width(context) * 0.75,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.2)),
                  child: Center(
                    child: Text(
                      'Powered By Dijlah ',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            foregroundWidget: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  elevation: 0,
                  flexibleSpace: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: customGradinet(context),
                    ),
                  ),
                  title: Text(
                    status is QuestionsContentLoaded ? 'الأسئلة' : 'التصنيفات',
                    style: TextStyle(color: Colors.white),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Assets.icons.question.image(color: Colors.yellow),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).scale(delay: 100.ms),
                  ],
                  leading: status is QuestionsContentLoaded
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            BlocProvider.of<QuestionCubit>(context)
                                .initalCategoryFetch();
                          },
                        )
                      : null,
                ),
                body: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: _buildBody(context, state, theme)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, QuestionState state, ThemeData theme) {
    final status = state.status;

    if (status is QuestionsLoading) {
      return Center(child: CustomLoading.fadingCircle(context));
    } else if (status is QuestionsError) {
      return ApiErrorWidget(
        onRetry: () async {
          await BlocProvider.of<QuestionCubit>(context).initalCategoryFetch();
        },
      );
    } else if (status is QuestionsCategoryLoaded) {
      return _buildCategoryList(context, status.data, theme);
    } else if (status is QuestionsContentLoaded) {
      return ItemQuestion.buildQuestionList(status.data);
    }

    return const SizedBox.shrink();
  }

  Widget _buildCategoryList(BuildContext context,
      List<QuestionCategoryModel> categories, ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async {
        await BlocProvider.of<QuestionCubit>(context).initalCategoryFetch();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(context, theme, category)
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .slideY(begin: 0.2);
        },
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, ThemeData theme, QuestionCategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          decoration: BoxDecoration(
              gradient: customGradinet(context), shape: BoxShape.circle),
          child: const Icon(Icons.question_answer_rounded, color: Colors.white)
              .padAll(14),
        ),
        title: Text(
          category.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${category.questionCount} سؤال',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
        onTap: () {
          BlocProvider.of<QuestionCubit>(context).categoryFetch(category.id);
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Image.asset(
          iconPath,
          color: Colors.white,
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
    );
  }
}
