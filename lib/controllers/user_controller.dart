import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coderecall/models/user_model.dart';
import 'package:coderecall/services/user_service.dart';
import 'package:coderecall/services/badge_service.dart';
import 'package:coderecall/utils/xp_calculator.dart';
import 'package:coderecall/utils/streak_helper.dart';

class UserController extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getInt('current_user_id');
      if (savedId != null) {
        _user = await _userService.getUserById(savedId);
      }
      // Fallback: if no saved ID or user not found, use most recently created user
      if (_user == null) {
        _user = await _userService.getMostRecentUser();
        if (_user != null) {
          await prefs.setInt('current_user_id', _user!.id!);
        }
      }
      // Recalculate level from XP to ensure consistency (bots have hardcoded levels)
      if (_user != null) {
        final correctLevel = XpCalculator.calculateLevel(_user!.xp);
        if (_user!.level != correctLevel) {
          _user = _user!.copyWith(level: correctLevel);
          await _userService.updateXp(_user!.id!, _user!.xp, correctLevel);
        }

        // Reset and re-evaluate badges against the correct user.
        // This fixes corrupted badge state caused by previous evaluations
        // against a different user (e.g., bot data from getFirstUser()).
        final badgeService = BadgeService();
        await badgeService.resetAllBadges();
        await badgeService.checkAndAwardBadges(_user!.id!);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(String username, int avatarIndex) async {
    _isLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now().toIso8601String();
      final user = UserModel(
        username: username,
        avatarIndex: avatarIndex,
        createdAt: now,
        lastActiveDate: StreakHelper.today,
        streakDays: 1,
      );
      final id = await _userService.insertUser(user);
      _user = user.copyWith(id: id);
      // Save the real user's ID so we load the right user on restart
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addXp(int xp) async {
    if (_user == null) return;
    final newXp = _user!.xp + xp;
    final newLevel = XpCalculator.calculateLevel(newXp);
    _user = _user!.copyWith(xp: newXp, level: newLevel);
    await _userService.updateXp(_user!.id!, newXp, newLevel);
    notifyListeners();
  }

  Future<void> checkStreak() async {
    if (_user == null) return;
    final newStreak = StreakHelper.checkAndUpdateStreak(
      _user!.streakDays,
      _user!.lastActiveDate,
    );
    final today = StreakHelper.today;
    _user = _user!.copyWith(streakDays: newStreak, lastActiveDate: today);
    await _userService.updateStreak(_user!.id!, newStreak, today);
    notifyListeners();
  }
}