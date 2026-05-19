import 'package:flutter/foundation.dart';
import 'package:coderecall/models/question_model.dart';
import 'package:coderecall/services/question_service.dart';
import 'package:coderecall/services/progress_service.dart';

class OutputController extends ChangeNotifier {
  final QuestionService _questionService = QuestionService();
  final ProgressService _progressService = ProgressService();

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isComplete = false;
  bool _isLoading = false;
  String? _error;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  bool get isCorrect => _isCorrect;
  bool get isComplete => _isComplete;
  bool get isLoading => _isLoading;
  String? get error => _error;

  QuestionModel? get currentQuestion {
    if (_currentIndex < _questions.length) return _questions[_currentIndex];
    return null;
  }

  Future<void> loadQuestions(String language) async {
    _isLoading = true;
    notifyListeners();
    try {
      _questions = await _questionService.getQuestions(
        language: language, type: 'output', limit: 10);
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
    final question = currentQuestion;
    if (question == null) return;
    _isCorrect = answer == question.correctAnswer;
    if (_isCorrect) _correctCount++;
    _showResult = true;
    notifyListeners();
  }

  Future<void> nextQuestion(int userId) async {
    final question = currentQuestion;
    if (question == null) return;
    try {
      await _progressService.updateOrInsertTopicProgress(
        userId, question.language, question.topic, _isCorrect);
      if (_currentIndex >= _questions.length - 1) {
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
    _questions = [];
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