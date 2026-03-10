import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/speech_to_text/presentation/providers/stt_provider.dart';
import 'features/text_to_speech/presentation/providers/tts_provider.dart';
import 'features/practice_mode/presentation/providers/practice_provider.dart';
import 'features/conversation/presentation/providers/conversation_provider.dart';
import 'features/history/presentation/providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => STTProvider()),
        ChangeNotifierProvider(create: (_) => TTSProvider()),
        ChangeNotifierProvider(create: (_) => PracticeProvider()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const EnglishPracticeApp(),
    ),
  );
}
