import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/text_comparator.dart';
import '../../../../core/widgets/animated_mic_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../text_to_speech/presentation/providers/tts_provider.dart';
import '../providers/practice_provider.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PracticeProvider>().loadNextSentence();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.practiceTitle,
        showBackButton: true,
      ),
      body: Consumer<PracticeProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category filter
                _buildCategoryFilter(provider),
                const SizedBox(height: 16),

                // Sentence card
                if (provider.currentSentence != null)
                  _buildSentenceCard(context, provider),
                const SizedBox(height: 24),

                // Mic button
                AnimatedMicButton(
                  isListening: provider.isListening,
                  onPressed: () {
                    if (provider.isListening) {
                      provider.stopPractice();
                    } else {
                      provider.startPractice();
                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  provider.isListening
                      ? AppStrings.listeningStatus
                      : 'Tap mic to start',
                  style: TextStyle(
                    color: provider.isListening
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Result
                if (provider.hasResult) ...[
                  _buildScoreCircle(provider.score),
                  const SizedBox(height: 16),
                  _buildWordChips(provider.wordMatches),
                  const SizedBox(height: 8),
                  Text(
                    'You said: "${provider.spokenText}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: provider.resetPractice,
                        child: const Text(AppStrings.tryAgain),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: provider.loadNextSentence,
                        child: const Text(AppStrings.nextSentence),
                      ),
                    ],
                  ),
                ],

                // Tip card
                if (provider.currentSentence?.tip != null) ...[
                  const SizedBox(height: 16),
                  _buildTipCard(provider.currentSentence!.tip!),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter(PracticeProvider provider) {
    final categories = [
      AppStrings.categoryAll,
      AppStrings.categoryBeginner,
      AppStrings.categoryIntermediate,
      AppStrings.categoryAdvanced,
    ];
    final categoryValues = ['all', 'beginner', 'intermediate', 'advanced'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (i) {
          final selected = provider.selectedCategory == categoryValues[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[i]),
              selected: selected,
              onSelected: (_) => provider.setCategory(categoryValues[i]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSentenceCard(
      BuildContext context, PracticeProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    provider.currentSentence!.sentence,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    final tts = context.read<TTSProvider>();
                    tts.updateText(provider.currentSentence!.sentence);
                    tts.speak();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.currentSentence!.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle(double score) {
    final percentage = (score * 100).round();
    Color borderColor;
    if (score < 0.5) {
      borderColor = AppColors.error;
    } else if (score < 0.8) {
      borderColor = AppColors.warning;
    } else {
      borderColor = AppColors.success;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: borderColor,
              ),
            ),
            const Text('Score', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildWordChips(List<WordMatch> wordMatches) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: wordMatches.map((wm) {
        if (wm.isCorrect) {
          return Chip(
            label: Text(wm.word),
            backgroundColor: AppColors.success.withValues(alpha: 0.2),
            side: const BorderSide(color: AppColors.success),
            avatar: const Icon(Icons.check, size: 16, color: AppColors.success),
          );
        } else if (wm.isMissing) {
          return Chip(
            label: Text(
              wm.word,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
          );
        } else {
          // Extra word
          return Chip(
            label: Text(
              wm.word,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            side: const BorderSide(color: Colors.blue),
          );
        }
      }).toList(),
    );
  }

  Widget _buildTipCard(String tip) {
    return Card(
      color: AppColors.warning.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.warning, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡 ', style: TextStyle(fontSize: 18)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.tip,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(tip, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
