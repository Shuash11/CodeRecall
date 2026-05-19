import 'package:sqflite/sqflite.dart';
import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/models/badge_model.dart';

/// Service for managing badge data operations.
class BadgeService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Retrieves all badges (both earned and unearned).
  Future<List<BadgeModel>> getAllBadges() async {
    final db = await _dbHelper.database;
    final result = await db.query('badges');
    return result.map((map) => BadgeModel.fromMap(map)).toList();
  }

  /// Retrieves only earned badges.
  Future<List<BadgeModel>> getEarnedBadges() async {
    final db = await _dbHelper.database;
    final result = await db.query('badges', where: 'is_earned = ?', whereArgs: [1]);
    return result.map((map) => BadgeModel.fromMap(map)).toList();
  }

  /// Marks a badge as earned with the current timestamp.
  Future<void> earnBadge(int badgeId) async {
    final db = await _dbHelper.database;
    await db.update(
      'badges',
      {'is_earned': 1, 'earned_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [badgeId],
    );
  }

  /// Resets all badges to unearned state.
  Future<void> resetAllBadges() async {
    final db = await _dbHelper.database;
    await db.update('badges', {'is_earned': 0, 'earned_at': null});
  }

  /// Checks and awards badges based on current user progress.
  /// Returns list of newly earned badge names.
  Future<List<String>> checkAndAwardBadges(int userId) async {
    final db = await _dbHelper.database;

    final allBadges = await getAllBadges();
    final newlyEarned = <String>[];

    for (final badge in allBadges) {
      if (badge.isEarned == 1) continue;

      bool earned = false;
      switch (badge.conditionType) {
        case 'quiz_count':
          final count = await _getQuizCount(db, userId);
          earned = count >= badge.conditionValue;
          break;
        case 'streak':
          final streak = await _getUserStreak(db, userId);
          earned = streak >= badge.conditionValue;
          break;
        case 'xp':
          final xp = await _getUserXp(db, userId);
          earned = xp >= badge.conditionValue;
          break;
        case 'java_correct':
          final count = await _getLanguageCorrectCount(db, userId, 'java');
          earned = count >= badge.conditionValue;
          break;
        case 'cpp_correct':
          final count = await _getLanguageCorrectCount(db, userId, 'cpp');
          earned = count >= badge.conditionValue;
          break;
        case 'perfect_score':
          final hasPerfect = await _hasPerfectQuiz(db, userId, badge.conditionValue);
          earned = hasPerfect;
          break;
        case 'topic_master':
          final mastered = await _hasMasteredTopic(db, userId, 'loops');
          earned = mastered;
          break;
        case 'retry_correct':
          // Simplified: check if user has retried and corrected wrong answers
          final count = await _getRetryCorrectCount(db, userId);
          earned = count >= badge.conditionValue;
          break;
        case 'algo_complete':
          // Check if user has viewed all 5 algorithms
          final completed = await _getAlgoProgress(db, userId);
          earned = completed >= badge.conditionValue;
          break;
      }

      if (earned && badge.id != null) {
        await earnBadge(badge.id!);
        newlyEarned.add(badge.name);
      }
    }

    return newlyEarned;
  }

  Future<int> _getQuizCount(Database db, int userId) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM quiz_sessions WHERE user_id = ?',
      [userId],
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> _getUserStreak(Database db, int userId) async {
    final result = await db.rawQuery(
      'SELECT streak_days FROM users WHERE id = ?',
      [userId],
    );
    return (result.first['streak_days'] as int?) ?? 0;
  }

  Future<int> _getUserXp(Database db, int userId) async {
    final result = await db.rawQuery(
      'SELECT xp FROM users WHERE id = ?',
      [userId],
    );
    return (result.first['xp'] as int?) ?? 0;
  }

  Future<int> _getLanguageCorrectCount(Database db, int userId, String language) async {
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(qa.is_correct), 0) as count
      FROM question_attempts qa
      INNER JOIN questions q ON qa.question_id = q.id
      WHERE qa.user_id = ? AND q.language = ? AND qa.is_correct = 1
    ''', [userId, language]);
    return (result.first['count'] as int?) ?? 0;
  }

  Future<bool> _hasPerfectQuiz(Database db, int userId, int questionCount) async {
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM quiz_sessions
      WHERE user_id = ? AND total_questions >= ? AND correct_answers = total_questions
    ''', [userId, questionCount]);
    final count = (result.first['count'] as int?) ?? 0;
    return count > 0;
  }

  Future<bool> _hasMasteredTopic(Database db, int userId, String topic) async {
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM topic_progress
      WHERE user_id = ? AND topic = ? AND mastery_level = 'expert'
    ''', [userId, topic]);
    final count = (result.first['count'] as int?) ?? 0;
    return count > 0;
  }

  Future<int> _getRetryCorrectCount(Database db, int userId) async {
    // Count questions that were answered wrong then later answered correct
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT qa1.question_id) as count
      FROM question_attempts qa1
      WHERE qa1.user_id = ? AND qa1.is_correct = 1
      AND EXISTS (
        SELECT 1 FROM question_attempts qa2
        WHERE qa2.user_id = qa1.user_id
        AND qa2.question_id = qa1.question_id
        AND qa2.is_correct = 0
        AND qa2.attempted_at < qa1.attempted_at
      )
    ''', [userId]);
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> _getAlgoProgress(Database db, int userId) async {
    // Placeholder: track completed algorithm views
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT topic) as count FROM topic_progress
      WHERE user_id = ? AND topic IN ('bubble_sort', 'linear_search', 'binary_search', 'stack', 'queue')
    ''', [userId]);
    return (result.first['count'] as int?) ?? 0;
  }
}
