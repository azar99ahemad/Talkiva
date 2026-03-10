import 'package:flutter/foundation.dart';

import '../../data/stt_service.dart';
import '../../../../core/utils/permission_handler.dart';

class STTProvider extends ChangeNotifier {
  final STTService _sttService = STTService();

  String _recognizedText = '';
  double _confidenceScore = 0.0;
  bool _isListening = false;
  bool _isAvailable = false;
  String? _errorMessage;
  String _selectedLocale = 'en_US';

  String get recognizedText => _recognizedText;
  double get confidenceScore => _confidenceScore;
  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;
  String? get errorMessage => _errorMessage;
  String get selectedLocale => _selectedLocale;

  Future<void> initialize() async {
    try {
      final hasPermission =
          await AppPermissionHandler.requestMicrophonePermission();
      if (!hasPermission) {
        _errorMessage = 'Microphone permission denied.';
        notifyListeners();
        return;
      }
      _isAvailable = await _sttService.initialize();
      if (!_isAvailable) {
        _errorMessage = 'Speech recognition not available on this device.';
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize: $e';
    }
    notifyListeners();
  }

  Future<void> startListening() async {
    if (!_isAvailable) {
      await initialize();
      if (!_isAvailable) return;
    }
    _errorMessage = null;
    _isListening = true;
    notifyListeners();

    try {
      await _sttService.startListening(
        onResult: (text) {
          _recognizedText = text;
          notifyListeners();
        },
        onConfidence: (confidence) {
          _confidenceScore = confidence;
          notifyListeners();
        },
        onListeningStop: () {
          _isListening = false;
          notifyListeners();
        },
        localeId: _selectedLocale,
      );
    } catch (e) {
      _errorMessage = 'Error while listening: $e';
      _isListening = false;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _sttService.stopListening();
    _isListening = false;
    notifyListeners();
  }

  void clearText() {
    _recognizedText = '';
    _confidenceScore = 0.0;
    notifyListeners();
  }

  void setLocale(String locale) {
    _selectedLocale = locale;
    notifyListeners();
  }
}
