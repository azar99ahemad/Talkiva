import '../../../../core/utils/text_comparator.dart';

class PracticeResult {
  final String id;
  final String originalSentence;
  final String spokenText;
  final double score;
  final List<WordMatch> wordMatches;
  final DateTime timestamp;

  const PracticeResult({
    required this.id,
    required this.originalSentence,
    required this.spokenText,
    required this.score,
    required this.wordMatches,
    required this.timestamp,
  });
}
