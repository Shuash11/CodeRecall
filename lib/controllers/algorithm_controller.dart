import 'package:flutter/foundation.dart';

class AlgorithmController extends ChangeNotifier {
  bool _isPlaying = false;
  final bool _isLoading = false;
  double _speed = 1.0;
  String _selectedAlgorithm = 'bubble_sort';
  String _statusMessage = 'Press Start to begin';

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  double get speed => _speed;
  String get selectedAlgorithm => _selectedAlgorithm;
  String get statusMessage => _statusMessage;

  void selectAlgorithm(String algo) {
    _selectedAlgorithm = algo;
    _statusMessage = 'Press Start to begin';
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    _statusMessage = _isPlaying ? 'Animating...' : 'Paused';
    notifyListeners();
  }

  void setSpeed(double val) {
    _speed = val;
    notifyListeners();
  }

  void nextStep() {
    _statusMessage = 'Step forward';
    notifyListeners();
  }

  void reset() {
    _isPlaying = false;
    _speed = 1.0;
    _statusMessage = 'Press Start to begin';
    notifyListeners();
  }
}