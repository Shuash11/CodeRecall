import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/services/seed_service.dart';
import 'package:coderecall/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    // Re-attempt DB init if it failed previously (e.g. from error screen retry)
    try {
      await DatabaseHelper().database;
      if (!await SeedService.isSeeded()) {
        await SeedService.seedAll();
      }
    } catch (e) {
      debugPrint('Splash DB init error: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.error);
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    if (!mounted) return;

    if (onboardingComplete) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.code, color: AppColors.accent, size: 80)
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut),
              const SizedBox(height: 24),
              Text(AppStrings.appName, style: AppTextStyles.heading.copyWith(fontSize: 32))
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut, delay: 150.ms),
              const SizedBox(height: 8),
              Text(AppStrings.onboardingSubtitle, style: AppTextStyles.bodyMuted)
                  .animate()
                  .fadeIn(duration: 600.ms, curve: Curves.easeOut, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}