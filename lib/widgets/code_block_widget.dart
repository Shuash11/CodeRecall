import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';

class CodeBlockWidget extends StatelessWidget {
  final String code;
  final double fontSize;

  const CodeBlockWidget({
    super.key,
    required this.code,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: fontSize,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}