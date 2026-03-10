
import 'package:Talkiva/core/utils/permission_handler.dart';
import 'package:Talkiva/features/conversation/data/chatbot_engine.dart';
import 'package:Talkiva/features/conversation/data/models/chat_message.dart';
import 'package:Talkiva/features/speech_to_text/data/stt_service.dart';
import 'package:Talkiva/features/text_to_speech/data/tts_service.dart';
import 'package:flutter/foundation.dart';



class ConversationProvider extends ChangeNotifier {
  final ChatbotEngine _chatbot = ChatbotEngine();
  final STTService _sttService = STTService();
  final TTSService _ttsService = TTSService();

  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isThinking = false;
  String? _errorMessage;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isThinking => _isThinking;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await _ttsService.initialize();
    _ttsService.onStart = () {
      _isSpeaking = true;
      notifyListeners();
    };
    _ttsService.onComplete = () {
      _isSpeaking = false;
      notifyListeners();
    };
  }

  void addWelcomeMessage() {
    _addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: "Hello! I'm EnglishBot. Start speaking or typing to practice your English! 🎉",
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.text,
    ));
  }

  Future<void> startListening() async {
    final hasPermission =
        await AppPermissionHandler.requestMicrophonePermission();
    if (!hasPermission) {
      _errorMessage = 'Microphone permission denied.';
      notifyListeners();
      return;
    }

    final available = await _sttService.initialize();
    if (!available) {
      _errorMessage = 'Speech recognition not available.';
      notifyListeners();
      return;
    }

    _isListening = true;
    _errorMessage = null;
    notifyListeners();

    String recognized = '';
    await _sttService.startListening(
      onResult: (text) {
        recognized = text;
      },
      onConfidence: (_) {},
      onListeningStop: () async {
        _isListening = false;
        notifyListeners();
        if (recognized.isNotEmpty) {
          await sendMessage(recognized);
        }
      },
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    ));

    _isThinking = true;
    notifyListeners();

    // Simulate thinking delay
    await Future.delayed(const Duration(milliseconds: 600));

    final reply = _chatbot.generateResponse(text);

    _isThinking = false;
    _addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.text,
    ));

    // Speak reply
    await _ttsService.speak(reply);
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearConversation() {
    _messages.clear();
    _isThinking = false;
    notifyListeners();
  }

  void stopSpeaking() {
    _ttsService.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> stopListening() async {
    await _sttService.stopListening();
    _isListening = false;
    notifyListeners();
  }
}
