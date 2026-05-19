import 'package:coderecall/database/database_helper.dart';
import 'package:coderecall/models/user_model.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertUser(UserModel user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getMostRecentUser() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', orderBy: 'id DESC', limit: 1);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<void> updateUser(UserModel user) async {
    final db = await _dbHelper.database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> updateXp(int userId, int xp, int level) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'xp': xp, 'level': level},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> updateStreak(int userId, int streakDays, String lastActiveDate) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'streak_days': streakDays, 'last_active_date': lastActiveDate},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsersOrderedByXp() async {
    final db = await _dbHelper.database;
    return await db.query('users', orderBy: 'xp DESC');
  }
}