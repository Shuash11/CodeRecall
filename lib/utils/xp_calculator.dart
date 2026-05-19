class XpCalculator {
  XpCalculator._();

  static const int easyCorrect = 5;
  static const int mediumCorrect = 10;
  static const int hardCorrect = 20;
  static const int perfectQuizBonus = 25;
  static const int dailyFirstSessionBonus = 15;

  static int getXpForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return easyCorrect;
      case 'medium':
        return mediumCorrect;
      case 'hard':
        return hardCorrect;
      default:
        return easyCorrect;
    }
  }

  static int getLevelThreshold(int level) {
    // Formula-based: each level requires (level * 100) XP to reach from previous
    // Total XP for level N = 50 * N * (N - 1)
    // Level 1: 0, Level 2: 100, Level 3: 300, Level 4: 600, Level 5: 1000, ...
    if (level <= 1) return 0;
    return 50 * level * (level - 1);
  }

  static double getXpProgressPercent(int currentLevel, int currentXp) {
    final currentThreshold = getLevelThreshold(currentLevel);
    final nextThreshold = getLevelThreshold(currentLevel + 1);
    final xpInLevel = currentXp - currentThreshold;
    final xpNeeded = nextThreshold - currentThreshold;
    if (xpNeeded <= 0) return 1.0;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }

  static int calculateLevel(int xp) {
    int level = 1;
    while (xp >= getLevelThreshold(level + 1)) {
      level++;
    }
    return level;
  }
}