import 'package:flutter/foundation.dart';
import 'package:coderecall/models/progress_model.dart';
import 'package:coderecall/models/quiz_model.dart';
import 'package:coderecall/models/badge_model.dart';
import 'package:coderecall/services/progress_service.dart';
import 'package:coderecall/services/quiz_service.dart';
import 'package:coderecall/services/badge_service.dart';

class ProgressController extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  final QuizService _quizService = QuizService();
  final BadgeService _badgeService = BadgeService();

  List<TopicProgressModel> _topicProgress = [];
  List<QuizSessionModel> _recentSessions = [];
  List<BadgeModel> _badges = [];
  List<Map<String, dynamic>> _weakTopics = [];
  bool _isLoading = false;
  String? _error;

  List<TopicProgressModel> get topicProgress => _topicProgress;
  List<QuizSessionModel> get recentSessions => _recentSessions;
  List<BadgeModel> get badges => _badges;
  List<Map<String, dynamic>> get weakTopics => _weakTopics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProgress(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Re-evaluate and award any newly earned badges based on current progress
      await _badgeService.checkAndAwardBadges(userId);

      _topicProgress = await _progressService.getTopicProgress(userId);
      _recentSessions = await _quizService.getRecentSessions(userId);
      _badges = await _badgeService.getAllBadges();
      _weakTopics = await _progressService.getWeakTopics(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}