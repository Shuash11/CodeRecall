import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/quiz_controller.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/animations/confetti_animation.dart';
import 'package:coderecall/services/badge_service.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen showing quiz results after completion.
class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _showConfetti = false;
  List<String> _newBadges = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final quizCtrl = context.read<QuizController>();
      final userCtrl = context.read<UserController>();

      // Award XP for perfect score bonus
      if (quizCtrl.accuracy >= 100 && quizCtrl.questions.length >= 5) {
        await userCtrl.addXp(25);
      }

      // Check for daily first session bonus (only once per day)
      if (userCtrl.user?.id != null) {
        final prefs = await SharedPreferences.getInstance();
        final todayDate = DateTime.now().toIso8601String().substring(0, 10);
        final lastBonusDate = prefs.getString('last_daily_bonus_date');
        if (lastBonusDate != todayDate) {
          await prefs.setString('last_daily_bonus_date', todayDate);
          await userCtrl.addXp(15);
        }
      }

      // Check badges
      if (userCtrl.user?.id != null) {
        final badgeService = BadgeService();
        _newBadges = await badgeService.checkAndAwardBadges(userCtrl.user!.id!);
      }

      // Show confetti for perfect or new badges
      if (quizCtrl.accuracy >= 100 || _newBadges.isNotEmpty) {
        setState(() => _showConfetti = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizCtrl = context.watch<QuizController>();
    final userCtrl = context.watch<UserController>();

    return ConfettiAnimation(
      trigger: _showConfetti,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Quiz Complete!'),
          backgroundColor: AppColors.surface,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Score circle
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: quizCtrl.accuracy >= 80 ? AppColors.correct : AppColors.xpGold,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${quizCtrl.correctCount}/${quizCtrl.questions.length}',
                        style: AppTextStyles.heading.copyWith(fontSize: 36),
                      ),
                      Text(
                        '${quizCtrl.accuracy.toStringAsFixed(0)}%',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Stats
              _buildStatRow('Score', '${quizCtrl.correctCount}/${quizCtrl.questions.length}'),
              _buildStatRow('Accuracy', '${quizCtrl.accuracy.toStringAsFixed(1)}%'),
              _buildStatRow('XP Earned', '+${quizCtrl.totalXpEarned} XP'),
              if (quizCtrl.accuracy >= 100 && quizCtrl.questions.length >= 5)
                _buildStatRow('Perfect Bonus', '+25 XP', isHighlight: true),

              // Newly earned badges
              if (_newBadges.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.xpGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events, color: AppColors.xpGold, size: 32),
                      const SizedBox(height: 8),
                      const Text('New Badges Earned!', style: AppTextStyles.subheading),
                      const SizedBox(height: 8),
                      ..._newBadges.map((badge) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppColors.xpGold, size: 18),
                            const SizedBox(width: 8),
                            Text(badge, style: AppTextStyles.body),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    quizCtrl.reset();
                    userCtrl.loadUser();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Home', style: AppTextStyles.buttonText),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    quizCtrl.reset();
                    Navigator.pushNamed(context, AppRoutes.quizHome);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Try Again', style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: isHighlight ? AppColors.xpGold : AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
