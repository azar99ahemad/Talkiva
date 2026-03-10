import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_themes.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/speech_to_text/presentation/screens/stt_screen.dart';
import 'features/text_to_speech/presentation/screens/tts_screen.dart';
import 'features/practice_mode/presentation/screens/practice_screen.dart';
import 'features/conversation/presentation/screens/conversation_screen.dart';
import 'features/history/presentation/screens/history_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class EnglishPracticeApp extends StatefulWidget {
  const EnglishPracticeApp({super.key});

  @override
  State<EnglishPracticeApp> createState() => _EnglishPracticeAppState();
}

class _EnglishPracticeAppState extends State<EnglishPracticeApp> {
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'English Practice',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/stt': (context) => const STTScreen(),
            '/tts': (context) => const TTSScreen(),
            '/practice': (context) => const PracticeScreen(),
            '/conversation': (context) => const ConversationScreen(),
            '/history': (context) => const HistoryScreen(),
          },
        );
      },
    );
  }
}
