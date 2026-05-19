import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/models/question_model.dart';

class QuestionService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<QuestionModel>> getQuestions({
    String? language,
    String? topic,
    String? difficulty,
    String? type,
    int? limit,
  }) async {
    final db = await _dbHelper.database;
    final conditions = <String>[];
    final params = <Object?>[];

    if (language != null) {
      conditions.add('language = ?');
      params.add(language);
    }
    if (topic != null) {
      conditions.add('topic = ?');
      params.add(topic);
    }
    if (difficulty != null) {
      conditions.add('difficulty = ?');
      params.add(difficulty);
    }
    if (type != null) {
      conditions.add('type = ?');
      params.add(type);
    }

    final where = conditions.isNotEmpty ? conditions.join(' AND ') : null;
    final orderBy = 'RANDOM()';
    final result = await db.query(
      'questions',
      where: where,
      whereArgs: params.isNotEmpty ? params : null,
      orderBy: orderBy,
      limit: limit,
    );

    return result.map((map) => QuestionModel.fromMap(map)).toList();
  }

  Future<QuestionModel?> getQuestionById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('questions', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return QuestionModel.fromMap(result.first);
  }

  Future<List<String>> getTopics(String language) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT topic FROM questions WHERE language = ? ORDER BY topic',
      [language],
    );
    return result.map((r) => r['topic'] as String).toList();
  }
}