class WordMatch {
  final String word;
  final bool isCorrect;
  final bool isMissing;
  final bool isExtra;

  const WordMatch({
    required this.word,
    required this.isCorrect,
    required this.isMissing,
    required this.isExtra,
  });
}

class TextComparator {
  static String _normalize(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r"[^\w\s']"), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static double calculateSimilarity(String original, String spoken) {
    final origWords = _normalize(original).split(' ');
    final spokenWords = _normalize(spoken).split(' ');

    if (origWords.isEmpty) return 0.0;

    int correct = 0;
    final spokenCopy = List<String>.from(spokenWords);

    for (final word in origWords) {
      if (spokenCopy.contains(word)) {
        correct++;
        spokenCopy.remove(word);
      }
    }

    return correct / origWords.length;
  }

  static List<WordMatch> compareWords(String original, String spoken) {
    final origWords = _normalize(original).split(' ');
    final spokenWords = _normalize(spoken).split(' ');

    final List<WordMatch> result = [];
    final spokenCopy = List<String>.from(spokenWords);

    // Mark correct and missing words from original
    for (final word in origWords) {
      if (spokenCopy.contains(word)) {
        result.add(WordMatch(
          word: word,
          isCorrect: true,
          isMissing: false,
          isExtra: false,
        ));
        spokenCopy.remove(word);
      } else {
        result.add(WordMatch(
          word: word,
          isCorrect: false,
          isMissing: true,
          isExtra: false,
        ));
      }
    }

    // Any remaining spoken words are extra
    for (final word in spokenCopy) {
      result.add(WordMatch(
        word: word,
        isCorrect: false,
        isMissing: false,
        isExtra: true,
      ));
    }

    return result;
  }
}
