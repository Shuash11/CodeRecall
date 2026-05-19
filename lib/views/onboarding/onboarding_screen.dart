import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _usernameController = TextEditingController();
  int _selectedAvatar = 0;
  final List<int> _avatars = [0, 1, 2, 3, 4, 5];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }
    await context.read<UserController>().createUser(username, _selectedAvatar);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Icon(Icons.code, color: AppColors.accent, size: 64),
              const SizedBox(height: 24),
              Text(AppStrings.onboardingTitle, style: AppTextStyles.heading, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(AppStrings.onboardingSubtitle, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: AppStrings.enterUsername,
                  hintStyle: AppTextStyles.bodyMuted,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 24),
              Text(AppStrings.chooseAvatar, style: AppTextStyles.subheading),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatars.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAvatar == _avatars[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = _avatars[index]),
                      child: Container(
                        width: 64,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          [Icons.person, Icons.face, Icons.smart_toy, Icons.code, Icons.computer, Icons.psychology][index],
                          color: isSelected ? AppColors.accent : AppColors.textMuted,
                          size: 36,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppStrings.getStarted, style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}