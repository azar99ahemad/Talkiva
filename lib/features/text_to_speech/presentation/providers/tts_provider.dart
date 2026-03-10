import 'package:flutter/foundation.dart';

import '../../data/tts_service.dart';

class TTSProvider extends ChangeNotifier {
  final TTSService _ttsService = TTSService();

  String _inputText = '';
  bool _isSpeaking = false;
  bool _isPaused = false;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;
  String _selectedLanguage = 'en-US';
  List<dynamic> _availableVoices = [];
  String? _selectedVoice;
  String? _errorMessage;

  String get inputText => _inputText;
  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;
  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;
  String get selectedLanguage => _selectedLanguage;
  List<dynamic> get availableVoices => _availableVoices;
  String? get selectedVoice => _selectedVoice;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    try {
      _ttsService.onStart = () {
        _isSpeaking = true;
        _isPaused = false;
        notifyListeners();
      };
      _ttsService.onComplete = () {
        _isSpeaking = false;
        _isPaused = false;
        notifyListeners();
      };
      _ttsService.onError = (error) {
        _errorMessage = error;
        _isSpeaking = false;
        _isPaused = false;
        notifyListeners();
      };
      await _ttsService.initialize();
      _availableVoices = await _ttsService.getAvailableVoices();
    } catch (e) {
      _errorMessage = 'Failed to initialize TTS: $e';
    }
    notifyListeners();
  }

  Future<void> speak() async {
    if (_inputText.trim().isEmpty) return;
    _errorMessage = null;
    try {
      await _ttsService.speak(_inputText);
    } catch (e) {
      _errorMessage = 'Error speaking: $e';
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _ttsService.pause();
    _isSpeaking = false;
    _isPaused = true;
    notifyListeners();
  }

  Future<void> stop() async {
    await _ttsService.stop();
    _isSpeaking = false;
    _isPaused = false;
    notifyListeners();
  }

  void updateText(String text) {
    _inputText = text;
    notifyListeners();
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _ttsService.setSpeechRate(rate);
    notifyListeners();
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _ttsService.setPitch(pitch);
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _ttsService.setVolume(volume);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    await _ttsService.setLanguage(language);
    notifyListeners();
  }

  Future<void> setVoice(String? voice) async {
    _selectedVoice = voice;
    notifyListeners();
  }
}
