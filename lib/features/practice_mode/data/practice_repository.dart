import 'dart:math';
import 'models/practice_sentence.dart';

class PracticeRepository {
  static final List<PracticeSentence> _sentences = [
    // Beginner
    const PracticeSentence(
      id: 'b1',
      sentence: 'The weather is nice today.',
      category: 'beginner',
      tip: 'Focus on the "th" sound in "the" and "weather".',
    ),
    const PracticeSentence(
      id: 'b2',
      sentence: 'I would like a cup of coffee.',
      category: 'beginner',
      tip: 'Say "would" as one syllable, not two.',
    ),
    const PracticeSentence(
      id: 'b3',
      sentence: 'How are you doing today?',
      category: 'beginner',
      tip: 'Use a rising intonation at the end of questions.',
    ),
    const PracticeSentence(
      id: 'b4',
      sentence: 'Can you help me please?',
      category: 'beginner',
      tip: 'Stress the word "help" for emphasis.',
    ),
    const PracticeSentence(
      id: 'b5',
      sentence: 'What time is it now?',
      category: 'beginner',
      tip: 'Link "What time" together smoothly.',
    ),
    const PracticeSentence(
      id: 'b6',
      sentence: 'I am learning English.',
      category: 'beginner',
      tip: 'Stress "learning" and "English" for clarity.',
    ),
    const PracticeSentence(
      id: 'b7',
      sentence: 'Please speak slowly.',
      category: 'beginner',
      tip: 'The "l" in "slowly" is important — don\'t drop it.',
    ),
    const PracticeSentence(
      id: 'b8',
      sentence: 'Where is the nearest store?',
      category: 'beginner',
      tip: 'Practice the "wh" question word smoothly.',
    ),
    const PracticeSentence(
      id: 'b9',
      sentence: 'I enjoy reading books.',
      category: 'beginner',
      tip: 'Both "enjoy" and "reading" should be clearly pronounced.',
    ),
    const PracticeSentence(
      id: 'b10',
      sentence: 'Thank you for your help.',
      category: 'beginner',
      tip: 'Don\'t forget the "k" sound in "thank".',
    ),

    // Intermediate
    const PracticeSentence(
      id: 'i1',
      sentence: 'I have been working here for five years.',
      category: 'intermediate',
      tip: 'Use the present perfect to show ongoing time.',
    ),
    const PracticeSentence(
      id: 'i2',
      sentence: 'Could you please repeat that more slowly?',
      category: 'intermediate',
      tip: 'Use polite intonation — don\'t sound demanding.',
    ),
    const PracticeSentence(
      id: 'i3',
      sentence: 'The meeting has been postponed until next week.',
      category: 'intermediate',
      tip: 'Stress "postponed" as it carries the key meaning.',
    ),
    const PracticeSentence(
      id: 'i4',
      sentence: "I'm looking forward to hearing from you.",
      category: 'intermediate',
      tip: '"Looking forward to" is a fixed phrase — practice it as a unit.',
    ),
    const PracticeSentence(
      id: 'i5',
      sentence: 'She suggested we try a different approach.',
      category: 'intermediate',
      tip: '"Suggested" is followed by the base form of the verb.',
    ),
    const PracticeSentence(
      id: 'i6',
      sentence: 'Despite the challenges, we managed to finish on time.',
      category: 'intermediate',
      tip: '"Despite" is followed by a noun phrase, not a clause.',
    ),
    const PracticeSentence(
      id: 'i7',
      sentence: 'The project requires careful planning and execution.',
      category: 'intermediate',
      tip: 'Stress "careful" and "execution" for emphasis.',
    ),
    const PracticeSentence(
      id: 'i8',
      sentence: 'He apologized for the misunderstanding.',
      category: 'intermediate',
      tip: '"Apologized for" is the standard collocation.',
    ),
    const PracticeSentence(
      id: 'i9',
      sentence: 'I would appreciate your feedback on this.',
      category: 'intermediate',
      tip: '"Would appreciate" is a polite, formal phrase.',
    ),
    const PracticeSentence(
      id: 'i10',
      sentence: 'They announced a significant change in policy.',
      category: 'intermediate',
      tip: 'Stress "significant" and "change" as key content words.',
    ),

    // Advanced
    const PracticeSentence(
      id: 'a1',
      sentence: 'The unprecedented economic downturn has affected millions.',
      category: 'advanced',
      tip: 'Practice "unprecedented" — it has 5 syllables.',
    ),
    const PracticeSentence(
      id: 'a2',
      sentence: 'She eloquently articulated her perspective on the matter.',
      category: 'advanced',
      tip: '"Eloquently" means speaking in a fluent and persuasive manner.',
    ),
    const PracticeSentence(
      id: 'a3',
      sentence:
          'The committee unanimously agreed to the proposed amendments.',
      category: 'advanced',
      tip: '"Unanimously" means all members agreed without exception.',
    ),
    const PracticeSentence(
      id: 'a4',
      sentence: 'His meticulous attention to detail was commendable.',
      category: 'advanced',
      tip: '"Meticulous" means very careful and precise.',
    ),
    const PracticeSentence(
      id: 'a5',
      sentence:
          'The paradigm shift in technology has transformed industries.',
      category: 'advanced',
      tip: 'Pronounce "paradigm" as "PAIR-a-dime".',
    ),
    const PracticeSentence(
      id: 'a6',
      sentence:
          'Notwithstanding the difficulties, progress was substantial.',
      category: 'advanced',
      tip: '"Notwithstanding" is a formal word meaning "in spite of".',
    ),
    const PracticeSentence(
      id: 'a7',
      sentence: 'The implications of this research are far-reaching.',
      category: 'advanced',
      tip: '"Far-reaching" describes something with wide effects.',
    ),
    const PracticeSentence(
      id: 'a8',
      sentence:
          'Her multifaceted approach to problem-solving impressed everyone.',
      category: 'advanced',
      tip: '"Multifaceted" means having many different aspects.',
    ),
    const PracticeSentence(
      id: 'a9',
      sentence: 'The nuances of the language took years to master.',
      category: 'advanced',
      tip: 'Pronounce "nuances" as "NOO-ahn-sez".',
    ),
    const PracticeSentence(
      id: 'a10',
      sentence: 'Ambiguity in the contract led to prolonged negotiations.',
      category: 'advanced',
      tip: '"Ambiguity" means uncertainty or multiple interpretations.',
    ),
  ];

  List<PracticeSentence> getSentences({String? category}) {
    if (category == null || category == 'all') return _sentences;
    return _sentences.where((s) => s.category == category).toList();
  }

  PracticeSentence getDailyPractice() {
    final dayOfYear = DateTime.now().difference(
          DateTime(DateTime.now().year, 1, 1),
        ).inDays;
    return _sentences[dayOfYear % _sentences.length];
  }

  List<PracticeSentence> getRandomSentences(int count) {
    final shuffled = List<PracticeSentence>.from(_sentences)..shuffle(Random());
    return shuffled.take(count).toList();
  }
}
