import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';

/// A small badge that shows the difficulty level with color coding.
class DifficultyBadgeWidget extends StatelessWidget {
  final String difficulty;

  const DifficultyBadgeWidget({
    super.key,
    required this.difficulty,
  });

  Color get _color {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.correct;
      case 'medium':
        return AppColors.xpGold;
      case 'hard':
        return AppColors.wrong;
      default:
        return AppColors.textMuted;
    }
  }

  String get _label {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
