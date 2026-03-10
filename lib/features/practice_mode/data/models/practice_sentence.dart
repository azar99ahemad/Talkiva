class PracticeSentence {
  final String id;
  final String sentence;
  final String category; // 'beginner', 'intermediate', 'advanced'
  final String? tip;
  final String? phonetic;

  const PracticeSentence({
    required this.id,
    required this.sentence,
    required this.category,
    this.tip,
    this.phonetic,
  });
}
