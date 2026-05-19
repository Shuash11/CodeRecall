import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/models/badge_model.dart';

/// A widget that displays a badge chip with icon and name.
/// Shows earned badges colorful and locked badges as greyed out.
class BadgeChipWidget extends StatelessWidget {
  final BadgeModel badge;
  final double size;

  const BadgeChipWidget({
    super.key,
    required this.badge,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEarned = badge.isEarned == 1;

    return Tooltip(
      message: isEarned ? badge.description : 'Locked - ${badge.description}',
      child: Container(
        width: size + 16,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isEarned
              ? AppColors.accent.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.textMuted.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(badge.iconCode, fontFamily: 'MaterialIcons'),
              color: isEarned ? AppColors.xpGold : AppColors.textMuted,
              size: size * 0.6,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                badge.name,
                style: AppTextStyles.caption.copyWith(
                  color: isEarned ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
