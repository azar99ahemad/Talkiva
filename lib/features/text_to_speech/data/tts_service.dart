import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  Function()? onStart;
  Function()? onComplete;
  Function(String error)? onError;

  Future<void> initialize() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      onStart?.call();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete?.call();
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      onError?.call(msg.toString());
    });
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _flutterTts.speak(text);
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _isSpeaking = false;
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  Future<List<dynamic>> getAvailableVoices() async {
    final voices = await _flutterTts.getVoices;
    return voices ?? [];
  }

  bool get isSpeaking => _isSpeaking;
}
