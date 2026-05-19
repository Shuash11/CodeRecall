import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coderecall/constants/app_colors.dart';
import 'package:coderecall/constants/app_strings.dart';
import 'package:coderecall/constants/app_text_styles.dart';
import 'package:coderecall/controllers/user_controller.dart';
import 'package:coderecall/widgets/xp_bar_widget.dart';
import 'package:coderecall/widgets/streak_flame_widget.dart';
import 'package:coderecall/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentTabNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<UserController>().loadUser();
      if (!mounted) return;
      await context.read<UserController>().checkStreak();
    });
  }

  @override
  void dispose() {
    _currentTabNotifier.dispose();
    super.dispose();
  }

  final List<Widget> _screens = const [
    _HomeTab(),
    _PracticeTab(),
    _AlgoTab(),
    _ProgressTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: ValueListenableBuilder<int>(
        valueListenable: _currentTabNotifier,
        builder: (context, tabIndex, _) => _screens[tabIndex],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _currentTabNotifier,
        builder: (context, tabIndex, _) {
          return BottomNavigationBar(
            currentIndex: tabIndex,
            onTap: (i) => _currentTabNotifier.value = i,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textMuted,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Practice'),
              BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Algorithms'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserController>().user;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Hello, ${user?.username ?? 'Coder'}!', style: AppTextStyles.heading),
            const SizedBox(height: 16),
            if (user != null) ...[
              XpBarWidget(currentXp: user.xp, currentLevel: user.level),
              const SizedBox(height: 16),
              StreakFlameWidget(streakDays: user.streakDays),
            ],
            const SizedBox(height: 32),
            _buildCard(context, Icons.quiz, AppStrings.quizHome, AppRoutes.quizHome),
            const SizedBox(height: 12),
            _buildCard(context, Icons.code, AppStrings.syntaxChallenge, AppRoutes.syntaxHome),
            const SizedBox(height: 12),
            _buildCard(context, Icons.output, AppStrings.outputPredictor, AppRoutes.outputHome),
            const SizedBox(height: 12),
            _buildCard(context, Icons.animation, AppStrings.algorithmVisualizer, AppRoutes.algorithmHome),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.subheading),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _PracticeTab extends StatelessWidget {
  const _PracticeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Practice', style: AppTextStyles.heading),
            const SizedBox(height: 24),
            _buildCard(context, Icons.quiz, AppStrings.quizHome, AppRoutes.quizHome),
            const SizedBox(height: 12),
            _buildCard(context, Icons.code, AppStrings.syntaxChallenge, AppRoutes.syntaxHome),
            const SizedBox(height: 12),
            _buildCard(context, Icons.output, AppStrings.outputPredictor, AppRoutes.outputHome),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.subheading),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _AlgoTab extends StatelessWidget {
  const _AlgoTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Algorithms', style: AppTextStyles.heading),
            const SizedBox(height: 24),
            _buildCard(context, Icons.animation, AppStrings.algorithmVisualizer, AppRoutes.algorithmHome),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.subheading),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Progress', style: AppTextStyles.heading),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart, color: AppColors.accent, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(AppStrings.dashboard, style: AppTextStyles.subheading),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserController>().user;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Profile', style: AppTextStyles.heading),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: AppColors.accent,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(user?.username ?? 'Coder', style: AppTextStyles.subheading),
                        ),
                        const SizedBox(height: 4),
                        Text('Level ${user?.level ?? 1}', style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.settings, color: AppColors.accent, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('Settings', style: AppTextStyles.subheading),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}