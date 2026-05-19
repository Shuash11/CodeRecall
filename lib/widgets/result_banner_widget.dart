import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';

/// A banner widget that displays quiz result feedback with animation support.
class ResultBannerWidget extends StatelessWidget {
  final bool isCorrect;
  final String? explanation;
  final int? xpEarned;

  const ResultBannerWidget({
    super.key,
    required this.isCorrect,
    this.explanation,
    this.xpEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.correct.withValues(alpha: 0.1)
            : AppColors.wrong.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? AppColors.correct : AppColors.wrong,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? AppColors.correct : AppColors.wrong,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect!',
                style: AppTextStyles.subheading.copyWith(
                  color: isCorrect ? AppColors.correct : AppColors.wrong,
                ),
              ),
              const Spacer(),
              if (xpEarned != null && isCorrect)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.xpGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppColors.xpGold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '+$xpEarned XP',
                        style: AppTextStyles.xpStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (explanation != null && explanation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              explanation!,
              style: AppTextStyles.bodyMuted.copyWith(fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
