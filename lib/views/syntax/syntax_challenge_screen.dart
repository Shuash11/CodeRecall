import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/syntax_controller.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/widgets/code_block_widget.dart';
import 'package:coderecall/widgets/option_card_widget.dart';
import 'package:coderecall/widgets/result_banner_widget.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen showing fill-in-the-blank syntax challenges.
class SyntaxChallengeScreen extends StatefulWidget {
  const SyntaxChallengeScreen({super.key});

  @override
  State<SyntaxChallengeScreen> createState() => _SyntaxChallengeScreenState();
}

class _SyntaxChallengeScreenState extends State<SyntaxChallengeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final lang = (args?['language'] as String?) ?? 'java';
      context.read<SyntaxController>().loadChallenges(lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    final syntaxCtrl = context.watch<SyntaxController>();
    final userCtrl = context.watch<UserController>();
    final challenge = syntaxCtrl.currentChallenge;

    if (syntaxCtrl.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Syntax Challenge'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    if (challenge == null) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Syntax Challenge'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: const Center(
          child: Text('No challenges available', style: AppTextStyles.bodyMuted),
        ),
      );
    }

    if (syntaxCtrl.isComplete) {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Complete!'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
                Text('Challenges Complete!', style: AppTextStyles.heading),
                const SizedBox(height: 8),
                Text(
                  '${syntaxCtrl.correctCount} / ${syntaxCtrl.challenges.length} correct',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    syntaxCtrl.reset();
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
        title: Text('Challenge ${syntaxCtrl.currentIndex + 1}/${syntaxCtrl.challenges.length}'),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: syntaxCtrl.challenges.isEmpty
                ? 0
                : (syntaxCtrl.currentIndex + 1) / syntaxCtrl.challenges.length,
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
                challenge.questionText,
                style: AppTextStyles.body.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Code snippet
            if (challenge.codeSnippet != null && challenge.codeSnippet!.isNotEmpty) ...[
              CodeBlockWidget(code: challenge.codeSnippet!),
              const SizedBox(height: 16),
            ],

            // Options in a styled container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: challenge.options.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final opt = entry.value;
                  if (opt.isEmpty) return const SizedBox.shrink();
                  return OptionCardWidget(
                    label: String.fromCharCode(65 + idx),
                    text: opt,
                    isSelected: syntaxCtrl.selectedAnswer == String.fromCharCode(65 + idx),
                    isCorrect: challenge.correctAnswer == String.fromCharCode(65 + idx),
                    showResult: syntaxCtrl.showResult,
                    onTap: () {
                      if (!syntaxCtrl.showResult) {
                        syntaxCtrl.selectAnswer(String.fromCharCode(65 + idx));
                      }
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Result banner
            if (syntaxCtrl.showResult) ...[
              ResultBannerWidget(
                isCorrect: syntaxCtrl.isCorrect,
                explanation: challenge.explanation,
                xpEarned: syntaxCtrl.isCorrect ? challenge.xpReward : null,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (syntaxCtrl.isCorrect && userCtrl.user?.id != null) {
                      userCtrl.addXp(challenge.xpReward);
                    }
                    syntaxCtrl.nextChallenge(userCtrl.user?.id ?? 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    syntaxCtrl.currentIndex >= syntaxCtrl.challenges.length - 1
                        ? 'See Results'
                        : 'Next Challenge',
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
