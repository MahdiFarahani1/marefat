import 'package:bookapp/features/questions/models/question_model.dart';
import 'package:bookapp/features/questions/view/questionContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemQuestion {
  static Widget buildQuestionList(List<QuestionModel> questions) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: ListView.separated(
          physics: BouncingScrollPhysics(),
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
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  title: Text(question.title),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
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
