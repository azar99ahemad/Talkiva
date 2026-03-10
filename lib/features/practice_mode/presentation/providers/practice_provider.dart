import 'package:flutter/foundation.dart';

import '../../data/models/practice_sentence.dart';
import '../../data/models/practice_result.dart';
import '../../data/practice_repository.dart';
import '../../../../core/utils/text_comparator.dart';
import '../../../../core/utils/permission_handler.dart';
import '../../../speech_to_text/data/stt_service.dart';

class PracticeProvider extends ChangeNotifier {
  final PracticeRepository _repository = PracticeRepository();
  final STTService _sttService = STTService();

  PracticeSentence? _currentSentence;
  String _spokenText = '';
  double _score = 0.0;
  List<WordMatch> _wordMatches = [];
  bool _isListening = false;
  bool _hasResult = false;
  String _selectedCategory = 'all';
  PracticeResult? _lastResult;

  PracticeSentence? get currentSentence => _currentSentence;
  String get spokenText => _spokenText;
  double get score => _score;
  List<WordMatch> get wordMatches => _wordMatches;
  bool get isListening => _isListening;
  bool get hasResult => _hasResult;
  String get selectedCategory => _selectedCategory;
  PracticeResult? get lastResult => _lastResult;

  void loadNextSentence() {
    final sentences = _repository.getSentences(category: _selectedCategory);
    if (sentences.isEmpty) return;
    final list = List<PracticeSentence>.from(sentences);
    list.shuffle();
    _currentSentence = list.first;
    resetPractice();
    notifyListeners();
  }

  void loadDailySentence() {
    _currentSentence = _repository.getDailyPractice();
    resetPractice();
    notifyListeners();
  }

  Future<void> startPractice() async {
    if (_currentSentence == null) return;

    final hasPermission =
        await AppPermissionHandler.requestMicrophonePermission();
    if (!hasPermission) return;

    final available = await _sttService.initialize();
    if (!available) return;

    _isListening = true;
    _hasResult = false;
    _spokenText = '';
    notifyListeners();

    await _sttService.startListening(
      onResult: (text) {
        _spokenText = text;
        notifyListeners();
      },
      onConfidence: (_) {},
      onListeningStop: () {
        _isListening = false;
        if (_spokenText.isNotEmpty) {
          evaluateResult(_spokenText);
        }
        notifyListeners();
      },
    );
  }

  Future<void> stopPractice() async {
    await _sttService.stopListening();
    _isListening = false;
    if (_spokenText.isNotEmpty) {
      evaluateResult(_spokenText);
    }
    notifyListeners();
  }

  void evaluateResult(String spokenText) {
    if (_currentSentence == null) return;
    _spokenText = spokenText;
    _score = TextComparator.calculateSimilarity(
        _currentSentence!.sentence, spokenText);
    _wordMatches = TextComparator.compareWords(
        _currentSentence!.sentence, spokenText);
    _hasResult = true;
    _lastResult = PracticeResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalSentence: _currentSentence!.sentence,
      spokenText: spokenText,
      score: _score,
      wordMatches: _wordMatches,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  void resetPractice() {
    _spokenText = '';
    _score = 0.0;
    _wordMatches = [];
    _hasResult = false;
    _isListening = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    loadNextSentence();
  }
}
