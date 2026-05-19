import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/models/quiz_model.dart';

class QuizService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertSession(QuizSessionModel session) async {
    final db = await _dbHelper.database;
    return await db.insert('quiz_sessions', session.toMap());
  }

  Future<List<QuizSessionModel>> getRecentSessions(int userId, {int limit = 10}) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'quiz_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'completed_at DESC',
      limit: limit,
    );
    return result.map((map) => QuizSessionModel.fromMap(map)).toList();
  }

  Future<int> getSessionCount(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM quiz_sessions WHERE user_id = ?',
      [userId],
    );
    return result.first['count'] as int;
  }

  Future<int> getTotalCorrectCount(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(correct_answers), 0) as total FROM quiz_sessions WHERE user_id = ?',
      [userId],
    );
    return result.first['total'] as int;
  }
}