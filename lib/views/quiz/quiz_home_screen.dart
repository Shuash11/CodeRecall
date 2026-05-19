import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/quiz_controller.dart';
import 'package:coderecall/routes/app_routes.dart';

/// Screen for configuring a quiz before starting.
class QuizHomeScreen extends StatefulWidget {
  const QuizHomeScreen({super.key});

  @override
  State<QuizHomeScreen> createState() => _QuizHomeScreenState();
}

class _QuizHomeScreenState extends State<QuizHomeScreen> {
  String _selectedLanguage = 'java';
  String _selectedTopic = 'variables';
  String _selectedDifficulty = 'easy';
  final int _questionCount = 10;

  final List<String> _languages = ['java', 'cpp'];
  final List<String> _topics = [
    'all', 'variables', 'data_types', 'operators', 'conditionals',
    'loops', 'arrays', 'methods', 'oop', 'exceptions', 'strings',
  ];
  final List<String> _cppTopics = [
    'all', 'variables', 'pointers', 'references', 'arrays',
    'functions', 'classes', 'constructors', 'stl_basics',
    'memory_management', 'loops', 'strings',
  ];

  List<String> get _currentTopics =>
      _selectedLanguage == 'java' ? _topics : _cppTopics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(AppStrings.quizHome),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            Text(AppStrings.selectLanguage, style: AppTextStyles.subheading),
            const SizedBox(height: 12),
            Row(
              children: _languages.map((lang) {
                final isSelected = _selectedLanguage == lang;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedLanguage = lang;
                      _selectedTopic = _currentTopics.first;
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.2)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.textMuted.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          lang == 'java' ? 'Java' : 'C++',
                          style: AppTextStyles.body.copyWith(
                            color: isSelected ? AppColors.accent : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Topic Selection
            Text(AppStrings.selectTopic, style: AppTextStyles.subheading),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentTopics.map((topic) {
                final isSelected = _selectedTopic == topic;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTopic = topic),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withValues(alpha: 0.2)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : Colors.transparent,
                      ),
                    ),                      child: Text(
                      topic == 'all'
                          ? 'ALL TOPICS'
                          : topic.replaceAll('_', ' ').toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? AppColors.accent : AppColors.textMuted,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Difficulty Selection
            Text(AppStrings.selectDifficulty, style: AppTextStyles.subheading),
            const SizedBox(height: 12),
            Row(
              children: ['all', 'easy', 'medium', 'hard'].map((difficulty) {
                final isSelected = _selectedDifficulty == difficulty;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDifficulty = difficulty),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.2)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.accent : AppColors.textMuted.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            difficulty == 'all'
                                ? 'All Levels'
                                : difficulty[0].toUpperCase() + difficulty.substring(1),
                            style: AppTextStyles.body.copyWith(
                              color: isSelected ? AppColors.accent : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const SizedBox(height: 32),

            // Start Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.read<QuizController>().setQuizConfig(
                    language: _selectedLanguage,
                    topic: _selectedTopic,
                    difficulty: _selectedDifficulty,
                    questionCount: _questionCount,
                  );
                  Navigator.pushNamed(context, AppRoutes.quizPlay);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppStrings.startQuiz, style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
