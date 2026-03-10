import 'dart:math';

class ChatbotEngine {
  static final Random _random = Random();

  static final List<MapEntry<RegExp, String>> _patterns = [
    // Greetings
    MapEntry(RegExp(r'\b(hello|hi|hey)\b'),
        "Hello! Great to see you here! Let's practice some English together! 😊"),
    MapEntry(RegExp(r'\bgood morning\b'),
        "Good morning! What a great time to practice English!"),
    MapEntry(RegExp(r'\b(good evening|good night)\b'),
        "Good evening! Ready for some English practice?"),

    // How are you
    MapEntry(RegExp(r'\b(how are you|how do you do)\b'),
        "I'm doing wonderfully, thank you for asking! How about you?"),
    MapEntry(RegExp(r'\bi am (fine|good|great|okay|ok)\b'),
        "That's wonderful to hear! Shall we continue practicing?"),
    MapEntry(RegExp(r'\bi am (not well|sick|tired)\b'),
        "I'm sorry to hear that! I hope you feel better soon. Take care!"),

    // Identity
    MapEntry(RegExp(r'\b(what is your name|who are you)\b'),
        "I'm EnglishBot, your personal English practice assistant! 🤖"),
    MapEntry(RegExp(r'\bhow old are you\b'),
        "I'm as old as your desire to learn English! Age is just a number. 😄"),
    MapEntry(RegExp(r'\bwhere are you from\b'),
        "I live in your device! I was created to help you practice English."),

    // Farewells
    MapEntry(RegExp(r'\b(goodbye|bye|see you|take care)\b'),
        "Goodbye! Keep practicing your English every single day! 👋"),
    MapEntry(RegExp(r'\bgood night\b'),
        "Good night! Dream in English tonight! 🌙"),

    // Weather
    MapEntry(RegExp(r'\b(weather|sunny|rainy|cloudy|hot|cold)\b'),
        "Weather is a great conversation topic! Can you describe today's weather in more detail?"),

    // Food
    MapEntry(RegExp(r'\b(food|eat|hungry|restaurant|cook)\b'),
        "Food vocabulary is important! What's your favorite meal?"),
    MapEntry(RegExp(r'\b(what do you eat|what is your favorite food)\b'),
        "I enjoy data, but I'm sure your food tastes much better! What do you like to eat?"),

    // Hobbies
    MapEntry(RegExp(r'\b(hobby|hobbies|what do you do|free time)\b'),
        "Having hobbies is wonderful! Can you tell me more about yours in English?"),
    MapEntry(RegExp(r'\bi like (reading|music|sports)\b'),
        "That's a great hobby! Can you tell me more about it?"),

    // English practice
    MapEntry(RegExp(r'\b(help me|help)\b'),
        "Of course! I'm here to help. Try speaking a sentence and I'll respond!"),
    MapEntry(RegExp(r'\b(practice|i want to practice)\b'),
        "Great attitude! Consistent practice is the key to fluency. Let's go!"),
    MapEntry(RegExp(r'\b(english|learn english|improve english)\b'),
        "You're doing amazing by practicing every day! What topic would you like to discuss?"),
    MapEntry(RegExp(r'\b(pronunciation|pronounce)\b'),
        "Pronunciation improves with regular practice. Try to listen and repeat after native speakers!"),
    MapEntry(RegExp(r'\bgrammar\b'),
        "Grammar is the backbone of language! Try forming a sentence and I'll help correct it."),
    MapEntry(RegExp(r'\b(vocabulary|words|new words)\b'),
        "Learning new words daily is key! Try to use each new word in a sentence."),

    // Questions
    MapEntry(RegExp(r'\bwhat time is it\b'),
        "It's always the perfect time to practice English! ⏰"),
    MapEntry(RegExp(r'\bwhat day is it\b'),
        "Every day is a great day to improve your English!"),
    MapEntry(RegExp(r'\bhow do you say\b'),
        "Great question! Try saying the word slowly, syllable by syllable."),
    MapEntry(RegExp(r'\bwhat does .* mean\b'),
        "Looking up new words is a great habit! You can also try to guess from context."),

    // Encouragement
    MapEntry(RegExp(r'\b(thank you|thanks|thank you very much)\b'),
        "You're very welcome! You're doing an amazing job! 🌟"),
    MapEntry(RegExp(r'\b(i am trying|i am practicing|i am studying)\b'),
        "Keep it up! Your dedication will definitely pay off! 💪"),
    MapEntry(RegExp(r'\b(i made a mistake|i am wrong|sorry)\b'),
        "Don't worry about mistakes! They are how we learn. Try again!"),
    MapEntry(RegExp(r"\bi don't understand\b"),
        "That's okay! Let's try again more slowly. Which part was unclear?"),

    // More identity
    MapEntry(RegExp(r'\bdo you speak\b'),
        "I speak English fluently! Let's have a conversation. 😊"),
    MapEntry(RegExp(r'\bdo you like\b'),
        "That's an interesting question! Tell me what you like."),
    MapEntry(RegExp(r'\bcan you help\b'),
        "Absolutely! I'm here to help you practice English. What would you like to work on?"),
    MapEntry(RegExp(r'\bwhat can you do\b'),
        "I can chat with you, help you practice pronunciation, and encourage your English learning journey!"),
    MapEntry(RegExp(r'\btell me about\b'),
        "Great curiosity! Tell me what you already know about the topic first."),
    MapEntry(RegExp(r'\bmy name is\b'),
        "Nice to meet you! How long have you been learning English?"),
    MapEntry(RegExp(r'\bi am from\b'),
        "How interesting! What language do people speak there? Can you teach me a word?"),
    MapEntry(RegExp(r'\bi work\b'),
        "Work is a great topic! Can you describe your job in English?"),
    MapEntry(RegExp(r'\bi study\b'),
        "Studying is so important! What subject are you studying?"),
    MapEntry(RegExp(r'\bfamily\b'),
        "Family is a wonderful topic! Can you describe your family in English?"),
    MapEntry(RegExp(r'\btravel\b'),
        "Travel is exciting! Where would you like to go? Describe it in English."),
    MapEntry(RegExp(r'\bmusic\b'),
        "Music is universal! Listening to English songs is a great way to improve!"),
    MapEntry(RegExp(r'\bmovie|film\b'),
        "Watching English movies is excellent for improving your listening skills!"),
    MapEntry(RegExp(r'\bbook\b'),
        "Reading English books is a fantastic way to build vocabulary!"),
    MapEntry(RegExp(r'\bsport\b'),
        "Sports have a lot of great vocabulary! What sport do you play?"),
    MapEntry(RegExp(r'\bcity\b'),
        "Cities are great topics! Can you describe your city in English?"),
    MapEntry(RegExp(r'\bcolor|colour\b'),
        "Colors are one of the first things we learn! Can you describe something using colors?"),
    MapEntry(RegExp(r'\bnumber\b'),
        "Numbers are very important! Try counting or using numbers in a sentence."),
    MapEntry(RegExp(r'\btime\b'),
        "Time expressions are very useful! Can you make a sentence using a time expression?"),
  ];

  static final List<String> _fallbackResponses = [
    "Interesting! Tell me more about that.",
    "That's a great sentence! Can you expand on it?",
    "I'm not sure I understood. Could you rephrase that?",
    "Let's keep the conversation going! Tell me something about your day.",
    "You're doing great! Keep speaking in English!",
    "Excellent effort! Can you elaborate on what you just said?",
    "I love your enthusiasm! What else would you like to talk about?",
    "That's wonderful! Try to use it in another sentence.",
  ];

  String generateResponse(String userInput) {
    final normalized = userInput.toLowerCase().trim();

    for (final pattern in _patterns) {
      if (pattern.key.hasMatch(normalized)) {
        return pattern.value;
      }
    }

    return _fallbackResponses[_random.nextInt(_fallbackResponses.length)];
  }
}
