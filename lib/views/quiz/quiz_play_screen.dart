import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/quiz_controller.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/widgets/code_block_widget.dart';
import 'package:coderecall/widgets/option_card_widget.dart';
import 'package:coderecall/widgets/result_banner_widget.dart';
import 'package:coderecall/animations/xp_gain_animation.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen for playing a quiz with questions and answers.
class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  final ValueNotifier<int> _xpAnimationTrigger = ValueNotifier<int>(0);
  bool _autoAdvancing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizController>().loadQuestions();
    });
  }

  @override
  void dispose() {
    _xpAnimationTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizCtrl = context.watch<QuizController>();
    final userCtrl = context.watch<UserController>();
    final question = quizCtrl.currentQuestion;

    if (quizCtrl.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (question == null) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Quiz'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(
          child: Text('No questions found', style: AppTextStyles.bodyMuted),
        ),
      );
    }

    // Navigate when quiz is complete
    if (quizCtrl.isQuizComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.quizResult);
        }
      });
    }

    return XpGainAnimation(
      xpAmount: quizCtrl.isCorrect ? (question.xpReward > 0 ? question.xpReward : 10) : 0,
      trigger: _xpAnimationTrigger.value > 0,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Text('Quiz (${quizCtrl.currentIndex + 1}/${quizCtrl.questions.length})'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: quizCtrl.progress,
              backgroundColor: AppColors.primary,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question text in a styled container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.2)),
                ),
                child: Text(
                  question.questionText,
                  style: AppTextStyles.body.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // Code snippet if present
              if (question.codeSnippet != null && question.codeSnippet!.isNotEmpty) ...[
                CodeBlockWidget(code: question.codeSnippet!),
                const SizedBox(height: 16),
              ],

              // Answer options in a container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: question.options.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final opt = entry.value;
                    if (opt.isEmpty) return const SizedBox.shrink();
                    return OptionCardWidget(
                      label: String.fromCharCode(65 + idx),
                      text: opt,
                      isSelected: quizCtrl.selectedAnswer == String.fromCharCode(65 + idx),
                      isCorrect: question.correctAnswer == String.fromCharCode(65 + idx),
                      showResult: quizCtrl.showResult,
                      onTap: () {
                        if (!quizCtrl.showResult) {
                          quizCtrl.selectAnswer(String.fromCharCode(65 + idx));
                          _xpAnimationTrigger.value++;
                          _triggerAutoAdvance(quizCtrl, userCtrl, question);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              // Result banner
              if (quizCtrl.showResult) ...[
                ResultBannerWidget(
                  isCorrect: quizCtrl.isCorrect,
                  explanation: question.explanation,
                  xpEarned: quizCtrl.isCorrect
                      ? (question.xpReward > 0 ? question.xpReward : 10)
                      : null,
                ),
                const SizedBox(height: 16),

                // Next button (manual fallback)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _handleNextQuestion(quizCtrl, userCtrl, question),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      quizCtrl.currentIndex >= quizCtrl.questions.length - 1
                          ? 'Show Results'
                          : 'Next Question',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _triggerAutoAdvance(QuizController quizCtrl, UserController userCtrl, dynamic question) {
    if (_autoAdvancing) return;
    _autoAdvancing = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && quizCtrl.showResult && !quizCtrl.isQuizComplete) {
        _handleNextQuestion(quizCtrl, userCtrl, question);
      }
      _autoAdvancing = false;
    });
  }

  void _handleNextQuestion(QuizController quizCtrl, UserController userCtrl, dynamic question) {
    if (quizCtrl.isCorrect && userCtrl.user?.id != null) {
      userCtrl.addXp(question.xpReward > 0 ? question.xpReward : 10);
    }
    quizCtrl.nextQuestion(userCtrl.user?.id ?? 0);
  }
}
