import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/controllers/progress_controller.dart';
import 'package:coderecall/widgets/xp_bar_widget.dart';
import 'package:coderecall/widgets/badge_chip_widget.dart';

/// Profile screen showing user information, stats, and badges.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryLoadProgress());
  }

  void _tryLoadProgress() {
    final user = context.read<UserController>().user;
    if (user?.id != null) {
      context.read<ProgressController>().loadProgress(user!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserController>().user;
    final progressCtrl = context.watch<ProgressController>();
    final earnedBadges = progressCtrl.badges.where((b) => b.isEarned == 1).toList();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar and name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                    child: _buildAvatarIcon(user?.avatarIndex),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.username ?? 'Coder',
                    style: AppTextStyles.heading.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level ${user?.level ?? 1}',
                    style: AppTextStyles.subheading.copyWith(
                      color: AppColors.accent, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joined ${user?.createdAt != null ? user!.createdAt.substring(0, 10) : 'Today'}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats grid
            if (user != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    XpBarWidget(currentXp: user.xp, currentLevel: user.level),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.star, '${user.xp}', 'Total XP'),
                        _buildStatItem(Icons.local_fire_department, '${user.streakDays}', 'Day Streak'),
                        _buildStatItem(Icons.emoji_events, '${earnedBadges.length}/${progressCtrl.badges.length}', 'Badges'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Achievement stats derived from actual progress
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Achievements', style: AppTextStyles.subheading),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildAchievementTile(
                          Icons.quiz,
                          '${progressCtrl.recentSessions.length}',
                          'Quizzes',
                          AppColors.accent,
                        ),
                        _buildAchievementTile(
                          Icons.check_circle,
                          '${_totalCorrectAnswers(progressCtrl)}',
                          'Correct',
                          AppColors.correct,
                        ),
                        _buildAchievementTile(
                          Icons.school,
                          '${_topicsMastered(progressCtrl)}',
                          'Mastered',
                          AppColors.xpGold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildAchievementTile(
                          Icons.trending_up,
                          '${_totalAttempted(progressCtrl)}',
                          'Attempts',
                          AppColors.textMuted,
                        ),
                        _buildAchievementTile(
                          Icons.speed,
                          '${_weakTopicsCount(progressCtrl)}',
                          'Needs Work',
                          AppColors.wrong,
                        ),
                        _buildAchievementTile(
                          Icons.code,
                          '${progressCtrl.topicProgress.length}',
                          'Topics',
                          AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Badges section
            if (progressCtrl.badges.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Badges', style: AppTextStyles.subheading),
                        Text(
                          '${earnedBadges.length} / ${progressCtrl.badges.length} earned',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.xpGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (earnedBadges.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.emoji_events, color: AppColors.textMuted.withValues(alpha: 0.4), size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'Complete quizzes and challenges to earn badges',
                                style: AppTextStyles.caption,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: progressCtrl.badges.map((badge) {
                          return BadgeChipWidget(badge: badge);
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Settings section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: AppTextStyles.subheading),
                  const SizedBox(height: 12),
                  _buildSettingItem(Icons.refresh, 'Reset Progress', () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: const Text('Reset Progress?', style: AppTextStyles.subheading),
                        content: const Text('This will delete all your data. Are you sure?', style: AppTextStyles.bodyMuted),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Placeholder: would need DB cleanup
                              Navigator.pop(ctx);
                            },
                            child: const Text('Reset', style: TextStyle(color: AppColors.wrong)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Icon _buildAvatarIcon(int? avatarIndex) {
    const avatars = [
      Icons.person,
      Icons.face,
      Icons.smart_toy,
      Icons.code,
      Icons.computer,
      Icons.psychology,
    ];
    final icon = (avatarIndex != null && avatarIndex >= 0 && avatarIndex < avatars.length)
        ? avatars[avatarIndex]
        : Icons.person;
    return Icon(icon, color: AppColors.accent, size: 44);
  }

  Widget _buildAchievementTile(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
          ),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  int _totalCorrectAnswers(ProgressController ctrl) {
    return ctrl.recentSessions.fold(0, (sum, s) => sum + s.correctAnswers);
  }

  int _topicsMastered(ProgressController ctrl) {
    return ctrl.topicProgress.where((t) => t.masteryLevel == 'expert').length;
  }

  int _totalAttempted(ProgressController ctrl) {
    return ctrl.topicProgress.fold(0, (sum, t) => sum + t.totalAttempted);
  }

  int _weakTopicsCount(ProgressController ctrl) {
    return ctrl.weakTopics.length;
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 28),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.heading.copyWith(fontSize: 20)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(label, style: AppTextStyles.body),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
