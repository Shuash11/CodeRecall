import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_text_styles.dart';

class StreakFlameWidget extends StatelessWidget {
  final int streakDays;

  const StreakFlameWidget({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department,
          color: streakDays > 0 ? AppColors.xpGold : AppColors.textMuted, size: 28),
        const SizedBox(width: 4),
        Text('$streakDays', style: AppTextStyles.heading.copyWith(
          color: streakDays > 0 ? AppColors.xpGold : AppColors.textMuted, fontSize: 20)),
        const SizedBox(width: 4),
        Text('days', style: AppTextStyles.caption.copyWith(
          color: streakDays > 0 ? AppColors.xpGold : AppColors.textMuted)),
      ],
    );
  }
}