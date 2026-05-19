import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/utils/xp_calculator.dart';

class XpBarWidget extends StatelessWidget {
  final int currentXp;
  final int currentLevel;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = XpCalculator.getXpProgressPercent(currentLevel, currentXp);
    final currentThreshold = XpCalculator.getLevelThreshold(currentLevel);
    final nextThreshold = XpCalculator.getLevelThreshold(currentLevel + 1);
    final xpInLevel = currentXp - currentThreshold;
    final xpNeeded = nextThreshold - currentThreshold;
    final displayXpNeeded = xpNeeded > 0 ? xpNeeded : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Level $currentLevel', style: AppTextStyles.caption),
            const Spacer(),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text('$xpInLevel / $displayXpNeeded XP', style: AppTextStyles.caption.copyWith(color: AppColors.xpGold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xpGold),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}