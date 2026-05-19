class DifficultyHelper {
  DifficultyHelper._();

  static const List<String> difficulties = ['easy', 'medium', 'hard'];

  static String getLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return difficulty;
    }
  }

  static int getXpMultiplier(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 4;
      default:
        return 1;
    }
  }
}