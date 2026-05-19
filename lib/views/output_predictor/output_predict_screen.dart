import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/output_controller.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/widgets/code_block_widget.dart';
import 'package:coderecall/widgets/option_card_widget.dart';
import 'package:coderecall/widgets/result_banner_widget.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen showing code snippets for output prediction.
class OutputPredictScreen extends StatefulWidget {
  const OutputPredictScreen({super.key});

  @override
  State<OutputPredictScreen> createState() => _OutputPredictScreenState();
}

class _OutputPredictScreenState extends State<OutputPredictScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final lang = (args?['language'] as String?) ?? 'java';
      context.read<OutputController>().loadQuestions(lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    final outputCtrl = context.watch<OutputController>();
    final userCtrl = context.watch<UserController>();
    final question = outputCtrl.currentQuestion;

    if (outputCtrl.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Output Predictor'),
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
          title: const Text('Output Predictor'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(
          child: Text('No questions available', style: AppTextStyles.bodyMuted),
        ),
      );
    }

    if (outputCtrl.isComplete) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Complete!'),
          backgroundColor: AppColors.surface,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: AppColors.correct, size: 80),
                const SizedBox(height: 20),
                const Text('All Done!', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                Text(
                  '${outputCtrl.correctCount} / ${outputCtrl.questions.length} correct',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    outputCtrl.reset();
                    Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.home, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Home', style: AppTextStyles.buttonText),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text('Question ${outputCtrl.currentIndex + 1}/${outputCtrl.questions.length}'),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: outputCtrl.questions.isEmpty
                ? 0
                : (outputCtrl.currentIndex + 1) / outputCtrl.questions.length,
            backgroundColor: AppColors.primary,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruction
            const Text(
              'What does this code print?',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),

            // Code snippet (must have one for output questions)
            if (question.codeSnippet != null && question.codeSnippet!.isNotEmpty) ...[
              CodeBlockWidget(code: question.codeSnippet!),
              const SizedBox(height: 16),
            ] else
              Text(question.questionText, style: AppTextStyles.body.copyWith(fontSize: 16)),

            const SizedBox(height: 8),

            // Options
            ...question.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              if (opt.isEmpty) return const SizedBox.shrink();
              return OptionCardWidget(
                label: String.fromCharCode(65 + idx),
                text: opt,
                isSelected: outputCtrl.selectedAnswer == String.fromCharCode(65 + idx),
                isCorrect: question.correctAnswer == String.fromCharCode(65 + idx),
                showResult: outputCtrl.showResult,
                onTap: () {
                  if (!outputCtrl.showResult) {
                    outputCtrl.selectAnswer(String.fromCharCode(65 + idx));
                  }
                },
              );
            }),

            const SizedBox(height: 12),

            // Result banner
            if (outputCtrl.showResult) ...[
              ResultBannerWidget(
                isCorrect: outputCtrl.isCorrect,
                explanation: question.explanation,
                xpEarned: outputCtrl.isCorrect ? question.xpReward : null,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (outputCtrl.isCorrect && userCtrl.user?.id != null) {
                      userCtrl.addXp(question.xpReward);
                    }
                    outputCtrl.nextQuestion(userCtrl.user?.id ?? 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    outputCtrl.currentIndex >= outputCtrl.questions.length - 1
                        ? 'See Results'
                        : 'Next Question',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
