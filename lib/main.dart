import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/controllers/quiz_controller.dart';
import 'package:coderecall/controllers/syntax_controller.dart';
import 'package:coderecall/controllers/output_controller.dart';
import 'package:coderecall/controllers/algorithm_controller.dart';
import 'package:coderecall/controllers/progress_controller.dart';
import 'package:coderecall/services/seed_service.dart';
import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/views/splash/splash_screen.dart';
import 'package:coderecall/views/onboarding/onboarding_screen.dart';
import 'package:coderecall/views/home/home_screen.dart';
import 'package:coderecall/views/quiz/quiz_home_screen.dart';
import 'package:coderecall/views/quiz/quiz_play_screen.dart';
import 'package:coderecall/views/quiz/quiz_result_screen.dart';
import 'package:coderecall/views/syntax/syntax_home_screen.dart';
import 'package:coderecall/views/syntax/syntax_challenge_screen.dart';
import 'package:coderecall/views/output_predictor/output_home_screen.dart';
import 'package:coderecall/views/output_predictor/output_predict_screen.dart';
import 'package:coderecall/views/algorithm/algorithm_home_screen.dart';
import 'package:coderecall/views/algorithm/algorithm_visualizer_screen.dart';
import 'package:coderecall/views/progress/progress_screen.dart';
import 'package:coderecall/views/profile/profile_screen.dart';
import 'package:coderecall/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool initSuccess = true;
  try {
    await DatabaseHelper().database;
    if (!await SeedService.isSeeded()) {
      await SeedService.seedAll();
    }
  } catch (e) {
    debugPrint('Initialization error: $e');
    initSuccess = false;
  }

  runApp(CodeRecallApp(initSuccess: initSuccess));
}class CodeRecallApp extends StatelessWidget {
  final bool initSuccess;
  const CodeRecallApp({super.key, required this.initSuccess});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => QuizController()),
        ChangeNotifierProvider(create: (_) => SyntaxController()),
        ChangeNotifierProvider(create: (_) => OutputController()),
        ChangeNotifierProvider(create: (_) => AlgorithmController()),
        ChangeNotifierProvider(create: (_) => ProgressController()),
      ],
      child: MaterialApp(
        title: 'CodeRecall',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.primary,
          fontFamily: 'JetBrainsMono',
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accent,
            surface: AppColors.surface,
          ),
        ),
        initialRoute: initSuccess ? AppRoutes.splash : AppRoutes.error,
        routes: {
          AppRoutes.error: (context) => _ErrorScreen(
            message: 'Failed to initialize database. Please restart the app.',
          ),
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.onboarding: (context) => const OnboardingScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.quizHome: (context) => const QuizHomeScreen(),
          AppRoutes.syntaxHome: (context) => const SyntaxHomeScreen(),
          AppRoutes.outputHome: (context) => const OutputHomeScreen(),
          AppRoutes.algorithmHome: (context) => const AlgorithmHomeScreen(),
          AppRoutes.progress: (context) => const ProgressScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          // Pass route arguments via ModalRoute — screens read them internally
          if (settings.name == AppRoutes.quizPlay) {
            return MaterialPageRoute(
              builder: (context) => const QuizPlayScreen(),
            );
          }
          if (settings.name == AppRoutes.quizResult) {
            return MaterialPageRoute(
              builder: (context) => const QuizResultScreen(),
            );
          }
          if (settings.name == AppRoutes.syntaxChallenge) {
            return MaterialPageRoute(
              builder: (context) => const SyntaxChallengeScreen(),
            );
          }
          if (settings.name == AppRoutes.outputPredict) {
            return MaterialPageRoute(
              builder: (context) => const OutputPredictScreen(),
            );
          }
          if (settings.name == AppRoutes.algorithmVisualizer) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const AlgorithmVisualizerScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.wrong, size: 64),
              const SizedBox(height: 24),
              Text(
                'Initialization Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.splash);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
