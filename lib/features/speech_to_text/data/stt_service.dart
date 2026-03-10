import 'package:speech_to_text/speech_to_text.dart';

class STTService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speechToText.initialize(
      onError: (error) {},
      onStatus: (status) {},
    );
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function(double confidence) onConfidence,
    required Function() onListeningStop,
    String localeId = 'en_US',
  }) async {
    _speechToText.statusListener = (status) {
      if (status == 'done' || status == 'notListening') {
        onListeningStop();
      }
    };
    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        if (result.hasConfidenceRating && result.confidence > 0) {
          onConfidence(result.confidence);
        }
      },
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  bool get isAvailable => _speechToText.isAvailable;
  bool get isListening => _speechToText.isListening;
}
