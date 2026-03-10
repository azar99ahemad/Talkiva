class AppStrings {
  // App
  static const String appName = 'English Practice';
  static const String appSubtitle = "Let's practice together";
  static const String greeting = 'Hello, English Learner! 👋';

  // Screen Titles
  static const String homeTitle = 'Home';
  static const String sttTitle = 'Speech to Text';
  static const String ttsTitle = 'Text to Speech';
  static const String practiceTitle = 'Practice Mode';
  static const String conversationTitle = 'Conversation Practice';
  static const String historyTitle = 'Practice History';

  // STT Screen
  static const String tapToSpeak = 'Tap the mic and start speaking...';
  static const String confidence = 'Confidence';
  static const String clearText = 'Clear';
  static const String selectLanguage = 'Select Language';
  static const String listeningStatus = 'Listening...';
  static const String notListening = 'Tap mic to start';

  // TTS Screen
  static const String enterText = 'Enter text to speak...';
  static const String play = 'Play';
  static const String pause = 'Pause';
  static const String stop = 'Stop';
  static const String slow = 'Slow';
  static const String normal = 'Normal';
  static const String fast = 'Fast';
  static const String pitch = 'Pitch';
  static const String volume = 'Volume';
  static const String speed = 'Speed';
  static const String selectVoice = 'Select Voice';

  // Practice Screen
  static const String categoryAll = 'All';
  static const String categoryBeginner = 'Beginner';
  static const String categoryIntermediate = 'Intermediate';
  static const String categoryAdvanced = 'Advanced';
  static const String tryAgain = '🔄 Try Again';
  static const String nextSentence = '➡ Next Sentence';
  static const String startPractice = 'Start Practice';
  static const String dailyPractice = "Today's Daily Practice";
  static const String tip = '💡 Tip';

  // Conversation Screen
  static const String typeMessage = 'Type a message...';
  static const String clearConversation = 'Clear';
  static const String welcomeMessage =
      "Hello! I'm EnglishBot. Start speaking or typing to practice your English! 🎉";

  // History Screen
  static const String totalSessions = 'Total\nSessions';
  static const String avgScore = 'Avg\nScore';
  static const String bestScore = 'Best\nScore';
  static const String dayStreak = 'Day\nStreak';
  static const String noHistory = 'No history yet.\nStart practicing!';
  static const String clearHistory = 'Clear History';
  static const String clearConfirm =
      'Are you sure you want to clear all history?';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // Permissions
  static const String micPermissionTitle = 'Microphone Permission Required';
  static const String micPermissionMessage =
      'This app needs microphone access to convert your speech to text. Please grant the permission.';
  static const String micPermissionDenied =
      'Microphone permission is required to use this feature.';
  static const String micPermissionPermanentlyDenied =
      'Microphone permission is permanently denied. Please enable it in app settings.';
  static const String openSettings = 'Open Settings';
  static const String retry = 'Retry';

  // Errors
  static const String sttNotAvailable =
      'Speech recognition is not available on this device.';
  static const String sttError = 'Error occurred while listening.';
  static const String ttsError = 'Error occurred while speaking.';
  static const String genericError = 'An error occurred. Please try again.';

  // Home Features
  static const String sttDescription = 'Convert your voice to text';
  static const String ttsDescription = 'Hear natural English voice';
  static const String practiceDescription = 'Improve pronunciation & accuracy';
  static const String conversationDescription = 'Chat with EnglishBot';

  // Tips
  static const List<String> englishTips = [
    'Practice speaking for at least 15 minutes every day.',
    'Listen to English podcasts or music to improve your ear.',
    'Read English articles aloud to practice pronunciation.',
    'Learn 5 new vocabulary words each day.',
    'Watch English movies with subtitles to improve comprehension.',
    'Record yourself speaking and listen back to identify areas for improvement.',
    'Practice with a language partner or tutor regularly.',
    'Use English in daily situations like shopping or ordering food.',
    'Focus on common phrases used in everyday conversation.',
    'Don\'t be afraid to make mistakes — they are how we learn!',
  ];
}
