import 'package:flutter/foundation.dart';
import 'package:coderecall/models/question_model.dart';
import 'package:coderecall/models/quiz_model.dart';
import 'package:coderecall/services/question_service.dart';
import 'package:coderecall/services/quiz_service.dart';
import 'package:coderecall/services/progress_service.dart';
import 'package:coderecall/utils/xp_calculator.dart';

class QuizController extends ChangeNotifier {
  final QuestionService _questionService = QuestionService();
  final QuizService _quizService = QuizService();
  final ProgressService _progressService = ProgressService();

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _totalXpEarned = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isQuizComplete = false;
  bool _isLoading = false;
  String? _error;
  int _timeTakenSeconds = 0;
  String _language = 'java';
  String _topic = 'variables';
  String _difficulty = 'easy';
  int _questionCount = 5;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get totalXpEarned => _totalXpEarned;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  bool get isCorrect => _isCorrect;
  bool get isQuizComplete => _isQuizComplete;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get timeTakenSeconds => _timeTakenSeconds;
  String get language => _language;
  String get topic => _topic;
  String get difficulty => _difficulty;
  int get questionCount => _questionCount;

  QuestionModel? get currentQuestion {
    if (_currentIndex < _questions.length) return _questions[_currentIndex];
    return null;
  }

  double get progress =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;
  double get accuracy =>
      _questions.isEmpty ? 0 : (_correctCount / _questions.length) * 100;

  void setQuizConfig({
    required String language,
    required String topic,
    required String difficulty,
    required int questionCount,
  }) {
    _language = language;
    _topic = topic;
    _difficulty = difficulty;
    _questionCount = questionCount;
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();
    try {
      _questions = await _questionService.getQuestions(
        language: _language,
        topic: _topic == 'all' ? null : _topic,
        difficulty: _difficulty == 'all' ? null : _difficulty,
        limit: _questionCount,
      );
      // If not enough questions at this difficulty, fill from all difficulties
      if (_questions.length < _questionCount) {
        final existingIds = _questions.map((q) => q.id).toSet();
        final fillCount = _questionCount - _questions.length;
        final fill = await _questionService.getQuestions(
          language: _language,
          topic: _topic == 'all' ? null : _topic,
          limit: fillCount,
        );
        for (final q in fill) {
          if (!existingIds.contains(q.id)) {
            _questions.add(q);
            existingIds.add(q.id);
          }
        }
      }
      // Still not enough? Fill from any topic for this language
      if (_questions.length < _questionCount) {
        final existingIds = _questions.map((q) => q.id).toSet();
        final fillCount = _questionCount - _questions.length;
        final fill = await _questionService.getQuestions(
          language: _language,
          limit: fillCount * 2, // fetch extra to account for possible duplicates
        );
        for (final q in fill) {
          if (!existingIds.contains(q.id) && _questions.length < _questionCount) {
            _questions.add(q);
            existingIds.add(q.id);
          }
        }
      }
      _currentIndex = 0;
      _correctCount = 0;
      _totalXpEarned = 0;
      _selectedAnswer = null;
      _showResult = false;
      _isCorrect = false;
      _isQuizComplete = false;
      _timeTakenSeconds = 0;
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
    final question = currentQuestion;
    if (question == null) return;
    _isCorrect = answer == question.correctAnswer;
    if (_isCorrect) {
      _correctCount++;
      _totalXpEarned += XpCalculator.getXpForDifficulty(question.difficulty);
    }
    _showResult = true;
    notifyListeners();
  }

  Future<void> nextQuestion(int userId) async {
    final question = currentQuestion;
    if (question == null) return;
    try {
      await _progressService.updateOrInsertTopicProgress(
        userId, question.language, question.topic, _isCorrect,
      );
      if (_currentIndex >= _questions.length - 1) {
        _isQuizComplete = true;
        await _saveQuizSession(userId);
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

  Future<void> _saveQuizSession(int userId) async {
    final session = QuizSessionModel(
      userId: userId,
      language: _language,
      topic: _topic,
      difficulty: _difficulty,
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      xpEarned: _totalXpEarned,
      timeTakenSeconds: _timeTakenSeconds,
      completedAt: DateTime.now().toIso8601String(),
    );
    await _quizService.insertSession(session);
  }

  void reset() {
    _questions = [];
    _currentIndex = 0;
    _correctCount = 0;
    _totalXpEarned = 0;
    _selectedAnswer = null;
    _showResult = false;
    _isCorrect = false;
    _isQuizComplete = false;
    _isLoading = false;
    _error = null;
    _timeTakenSeconds = 0;
    notifyListeners();
  }
}