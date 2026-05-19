import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/progress_controller.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/widgets/xp_bar_widget.dart';
import 'package:coderecall/widgets/streak_flame_widget.dart';
import 'package:coderecall/widgets/badge_chip_widget.dart';
import 'package:coderecall/utils/date_utils.dart';

/// Progress dashboard screen showing XP, streaks, topic mastery, weak topics, quiz history, and badges.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserController>().user;
      if (user?.id != null) {
        context.read<ProgressController>().loadProgress(user!.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserController>().user;
    final progressCtrl = context.watch<ProgressController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: progressCtrl.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // XP & Streak section
                  if (user != null) ...[
                    Row(
                      children: [
                        Expanded(child: XpBarWidget(currentXp: user.xp, currentLevel: user.level)),
                        const SizedBox(width: 16),
                        StreakFlameWidget(streakDays: user.streakDays),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${user.xp} XP Total',
                        style: AppTextStyles.xpStyle.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Topic Mastery
                  if (progressCtrl.topicProgress.isNotEmpty) ...[
                    Text(AppStrings.topicMastery, style: AppTextStyles.subheading),
                    const SizedBox(height: 12),
                    ...progressCtrl.topicProgress.map((topic) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              topic.masteryLevel == 'expert'
                                  ? Icons.check_circle
                                  : topic.masteryLevel == 'intermediate'
                                      ? Icons.trending_up
                                      : Icons.radio_button_unchecked,
                              color: topic.masteryLevel == 'expert'
                                  ? AppColors.correct
                                  : topic.masteryLevel == 'intermediate'
                                      ? AppColors.xpGold
                                      : AppColors.textMuted,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${topic.language.toUpperCase()} — ${topic.topic.replaceAll('_', ' ')}',
                                    style: AppTextStyles.body.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    '${topic.totalAttempted} attempts, ${topic.totalCorrect} correct',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: topic.masteryLevel == 'expert'
                                    ? AppColors.correct.withValues(alpha: 0.15)
                                    : topic.masteryLevel == 'intermediate'
                                        ? AppColors.xpGold.withValues(alpha: 0.15)
                                        : AppColors.textMuted.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                topic.masteryLevel[0].toUpperCase() + topic.masteryLevel.substring(1),
                                style: AppTextStyles.caption.copyWith(
                                  color: topic.masteryLevel == 'expert'
                                      ? AppColors.correct
                                      : topic.masteryLevel == 'intermediate'
                                          ? AppColors.xpGold
                                          : AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 20),

                  // Weak Topics
                  if (progressCtrl.weakTopics.isNotEmpty) ...[
                    Text(AppStrings.weakTopics, style: AppTextStyles.subheading),
                    const SizedBox(height: 12),
                    ...progressCtrl.weakTopics.map((topic) {
                      final rate = (topic['correct_rate'] as num?)?.toDouble() ?? 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.wrong.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.wrong.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber, color: AppColors.wrong, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${topic['language']} — ${topic['topic']}',
                                    style: AppTextStyles.body.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    '${topic['total_attempted']} attempts',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${rate.toStringAsFixed(0)}%',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.wrong,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],

                  // Quiz History
                  Text(AppStrings.quizHistory, style: AppTextStyles.subheading),
                  const SizedBox(height: 12),
                  if (progressCtrl.recentSessions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(AppStrings.noSessionsYet, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                    )
                  else
                    ...progressCtrl.recentSessions.take(10).map((session) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${session.language.toUpperCase()} — ${session.topic ?? 'Mixed'}',
                                    style: AppTextStyles.body.copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    AppDateUtils.timeAgo(session.completedAt),
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${session.correctAnswers}/${session.totalQuestions}',
                              style: AppTextStyles.body.copyWith(
                                color: session.accuracyPercent >= 80
                                    ? AppColors.correct
                                    : session.accuracyPercent >= 50
                                        ? AppColors.xpGold
                                        : AppColors.wrong,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '+${session.xpEarned}',
                                style: AppTextStyles.xpStyle.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 20),

                  // Badges Shelf
                  Text(AppStrings.badges, style: AppTextStyles.subheading),
                  const SizedBox(height: 12),
                  if (progressCtrl.badges.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('No badges yet', style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: progressCtrl.badges.map((badge) {
                          return BadgeChipWidget(badge: badge);
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
