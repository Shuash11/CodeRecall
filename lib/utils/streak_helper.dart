import 'package:intl/intl.dart';

class StreakHelper {
  StreakHelper._();

  static String get today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static String get yesterday =>
      DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));

  static bool isConsecutiveDay(String lastActiveDate) {
    return lastActiveDate == yesterday || lastActiveDate == today;
  }

  static bool isGapMoreThanOneDay(String lastActiveDate) {
    if (lastActiveDate == today || lastActiveDate == yesterday) return false;
    final lastDate = DateTime.tryParse(lastActiveDate);
    if (lastDate == null) return false;
    final diff = DateTime.now().difference(lastDate).inDays;
    return diff > 1;
  }

  static int checkAndUpdateStreak(int currentStreak, String? lastActiveDate) {
    if (lastActiveDate == null) return 1;
    if (lastActiveDate == today) return currentStreak;
    if (lastActiveDate == yesterday) return currentStreak + 1;
    return 0;
  }
}