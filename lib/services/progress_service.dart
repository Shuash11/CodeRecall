import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/models/progress_model.dart';

class ProgressService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<TopicProgressModel>> getTopicProgress(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'topic_progress',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((map) => TopicProgressModel.fromMap(map)).toList();
  }

  Future<TopicProgressModel?> getTopicProgressForUser(
      int userId, String language, String topic) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'topic_progress',
      where: 'user_id = ? AND language = ? AND topic = ?',
      whereArgs: [userId, language, topic],
    );
    if (result.isEmpty) return null;
    return TopicProgressModel.fromMap(result.first);
  }

  Future<void> updateOrInsertTopicProgress(
      int userId, String language, String topic, bool isCorrect) async {
    final db = await _dbHelper.database;
    final existing = await getTopicProgressForUser(userId, language, topic);

    if (existing != null) {
      final newAttempted = existing.totalAttempted + 1;
      final newCorrect = existing.totalCorrect + (isCorrect ? 1 : 0);
      final newMastery = _calculateMastery(newAttempted, newCorrect);
      await db.update(
        'topic_progress',
        {
          'total_attempted': newAttempted,
          'total_correct': newCorrect,
          'mastery_level': newMastery,
          'last_practiced': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [existing.id],
      );
    } else {
      await db.insert('topic_progress', {
        'user_id': userId,
        'language': language,
        'topic': topic,
        'total_attempted': 1,
        'total_correct': isCorrect ? 1 : 0,
        'mastery_level': 'beginner',
        'last_practiced': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getWeakTopics(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT language, topic, total_attempted, total_correct,
             (CAST(total_correct AS REAL) / total_attempted) * 100 as correct_rate
      FROM topic_progress
      WHERE user_id = ? AND total_attempted > 0
      ORDER BY correct_rate ASC
      LIMIT 3
    ''', [userId]);
    return result;
  }

  String _calculateMastery(int attempted, int correct) {
    if (attempted < 5) return 'beginner';
    final rate = correct / attempted;
    if (rate >= 0.8) return 'expert';
    if (rate >= 0.5) return 'intermediate';
    return 'beginner';
  }
}