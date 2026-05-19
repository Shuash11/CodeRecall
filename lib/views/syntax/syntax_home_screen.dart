import 'package:flutter/material.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen for selecting language to start syntax challenges.
class SyntaxHomeScreen extends StatelessWidget {
  const SyntaxHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(AppStrings.syntaxChallenge),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Choose a Language',
              style: AppTextStyles.subheading,
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the blanks to complete the code syntax',
              style: AppTextStyles.bodyMuted,
            ),
            const SizedBox(height: 32),
            _buildLangCard(context, 'Java', Icons.coffee, 'java'),
            const SizedBox(height: 16),
            _buildLangCard(context, 'C++', Icons.code, 'cpp'),
          ],
        ),
      ),
    );
  }

  Widget _buildLangCard(BuildContext context, String title, IconData icon, String lang) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.syntaxChallenge,
        arguments: {'language': lang},
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subheading),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('$title Syntax Challenges', style: AppTextStyles.caption),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
