import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/features/questions/models/question_model.dart';
import 'package:bookapp/features/questions/view/questionContent.dart';
import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemQuestion {
  static Widget buildQuestionList(List<QuestionModel> questions) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: questions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final question = questions[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionsContent(
                      awnser: question.answer,
                      question: question.title,
                    ),
                  )),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.tertiary.withAlpha(100),
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(question.title),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: customGradinet(),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                ),
              ),
            );
          }),
    );
  }
}
