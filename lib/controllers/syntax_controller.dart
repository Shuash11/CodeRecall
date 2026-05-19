import 'package:flutter/foundation.dart';
import 'package:coderecall/models/question_model.dart';
import 'package:coderecall/services/question_service.dart';
import 'package:coderecall/services/progress_service.dart';

class SyntaxController extends ChangeNotifier {
  final QuestionService _questionService = QuestionService();
  final ProgressService _progressService = ProgressService();

  List<QuestionModel> _challenges = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isComplete = false;
  bool _isLoading = false;
  String? _error;

  List<QuestionModel> get challenges => _challenges;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  bool get isCorrect => _isCorrect;
  bool get isComplete => _isComplete;
  bool get isLoading => _isLoading;
  String? get error => _error;

  QuestionModel? get currentChallenge {
    if (_currentIndex < _challenges.length) return _challenges[_currentIndex];
    return null;
  }

  Future<void> loadChallenges(String language) async {
    _isLoading = true;
    notifyListeners();
    try {
      _challenges = await _questionService.getQuestions(
        language: language, type: 'fillblank', limit: 10);
      _currentIndex = 0;
      _correctCount = 0;
      _selectedAnswer = null;
      _showResult = false;
      _isCorrect = false;
      _isComplete = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    if (_showResult) return;
    _selectedAnswer = answer;
    final challenge = currentChallenge;
    if (challenge == null) return;
    _isCorrect = answer == challenge.correctAnswer;
    if (_isCorrect) _correctCount++;
    _showResult = true;
    notifyListeners();
  }

  Future<void> nextChallenge(int userId) async {
    final challenge = currentChallenge;
    if (challenge == null) return;
    try {
      await _progressService.updateOrInsertTopicProgress(
        userId, challenge.language, challenge.topic, _isCorrect);
      if (_currentIndex >= _challenges.length - 1) {
        _isComplete = true;
      } else {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      }
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  void reset() {
    _challenges = [];
    _currentIndex = 0;
    _correctCount = 0;
    _selectedAnswer = null;
    _showResult = false;
    _isCorrect = false;
    _isComplete = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}