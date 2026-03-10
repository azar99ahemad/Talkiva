import 'package:Talkiva/core/utils/text_comparator.dart';
import 'package:Talkiva/features/conversation/data/chatbot_engine.dart';
import 'package:Talkiva/features/practice_mode/data/practice_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextComparator', () {
    test('calculateSimilarity returns 1.0 for identical strings', () {
      expect(
        TextComparator.calculateSimilarity(
            'hello world', 'hello world'),
        1.0,
      );
    });

    test('calculateSimilarity returns 0.0 for completely different strings',
        () {
      expect(
        TextComparator.calculateSimilarity('hello world', 'foo bar'),
        0.0,
      );
    });

    test('calculateSimilarity ignores case', () {
      expect(
        TextComparator.calculateSimilarity(
            'Hello World', 'hello world'),
        1.0,
      );
    });

    test('compareWords marks correct words', () {
      final matches =
          TextComparator.compareWords('hello world', 'hello world');
      expect(matches.every((m) => m.isCorrect), isTrue);
    });

    test('compareWords marks missing words', () {
      final matches = TextComparator.compareWords('hello world', 'hello');
      expect(matches.any((m) => m.isMissing && m.word == 'world'), isTrue);
    });

    test('compareWords marks extra words', () {
      final matches =
          TextComparator.compareWords('hello', 'hello world');
      expect(matches.any((m) => m.isExtra && m.word == 'world'), isTrue);
    });
  });

  group('PracticeRepository', () {
    final repo = PracticeRepository();

    test('getSentences returns all 30 sentences', () {
      expect(repo.getSentences().length, 30);
    });

    test('getSentences filters by category', () {
      final beginners = repo.getSentences(category: 'beginner');
      expect(beginners.length, 10);
      expect(beginners.every((s) => s.category == 'beginner'), isTrue);
    });

    test('getDailyPractice returns a sentence', () {
      final daily = repo.getDailyPractice();
      expect(daily.sentence, isNotEmpty);
    });

    test('getRandomSentences returns correct count', () {
      expect(repo.getRandomSentences(5).length, 5);
    });
  });

  group('ChatbotEngine', () {
    final engine = ChatbotEngine();

    test('responds to hello', () {
      final response = engine.generateResponse('hello');
      expect(response, isNotEmpty);
    });

    test('responds to how are you', () {
      final response = engine.generateResponse('how are you');
      expect(response, isNotEmpty);
    });

    test('returns fallback for unknown input', () {
      final response = engine.generateResponse('xyzunknown123');
      expect(response, isNotEmpty);
    });
  });
}
