import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';

class OptionCardWidget extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const OptionCardWidget({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.textMuted.withValues(alpha: 0.3);
    Color textColor = AppColors.textPrimary;

    if (showResult) {
      if (isCorrect) {
        bgColor = AppColors.correct.withValues(alpha: 0.15);
        borderColor = AppColors.correct;
        textColor = AppColors.correct;
      } else if (isSelected && !isCorrect) {
        bgColor = AppColors.wrong.withValues(alpha: 0.15);
        borderColor = AppColors.wrong;
        textColor = AppColors.wrong;
      }
    } else if (isSelected) {
      bgColor = AppColors.accent.withValues(alpha: 0.15);
      borderColor = AppColors.accent;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? (showResult && isCorrect ? AppColors.correct : AppColors.accent)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(label, style: AppTextStyles.body.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: AppTextStyles.body.copyWith(color: textColor))),
            if (showResult && isCorrect)
              const Icon(Icons.check_circle, color: AppColors.correct, size: 24),
            if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppColors.wrong, size: 24),
          ],
        ),
      ),
    );
  }
}