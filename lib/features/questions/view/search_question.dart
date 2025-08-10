import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/features/questions/bloc/questionSearch/question_search_cubit.dart';
import 'package:bookapp/features/questions/widgets/item_question.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:bookapp/shared/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';

class SearchQuestionPage extends StatelessWidget {
  const SearchQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar.littleAppBar(context, title: 'البحث'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Input
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    context.read<QuestionSearchCubit>().serchData(value.trim());
                  }
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن سؤال أو كلمة مفتاحية...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Assets.newicons.search
                      .image(
                          color: Theme.of(context).primaryColor,
                          width: 15,
                          height: 15)
                      .padAll(12),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📋 Bloc state builder

            Expanded(
              child: BlocBuilder<QuestionSearchCubit, QuestionSearchState>(
                builder: (context, state) {
                  if (state is QuestionSearchLoading) {
                    return Center(child: CustomLoading.fadingCircle(context));
                  }

                  if (state is QuestionSearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.icons.warning.image(
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'لم يتم العثور على نتائج.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'حاول استخدام كلمات مفتاحية مختلفة.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade(delay: 400.ms);
                  }

                  if (state is QuestionSearchLoaded) {
                    print('sdfsdgsdf');
                    if (state.data.isEmpty) {
                      return const Center(child: Text("لا توجد نتائج مطابقة."));
                    }

                    return ItemQuestion.buildQuestionList(state.data);
                  }
                  if (state is QuestionSearchInit) {
                    return SizedBox();
                  }
                  return const Center(
                    child: Text("ابدأ بكتابة ما تريد البحث عنه."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
