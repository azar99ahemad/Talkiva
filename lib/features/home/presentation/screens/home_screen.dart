import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../practice_mode/data/practice_repository.dart';
import '../../../history/presentation/providers/history_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PracticeRepository _practiceRepo = PracticeRepository();
  int _currentTipIndex = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentTipIndex =
        DateTime.now().day % AppStrings.englishTips.length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.appName),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const _PracticeTab(),
          const _HistoryTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.homeTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_outlined),
            selectedIcon: Icon(Icons.mic),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final daily = _practiceRepo.getDailyPractice();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          const Text(
            AppStrings.greeting,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            AppStrings.appSubtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Daily practice card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.wb_sunny, color: AppColors.warning),
                      SizedBox(width: 8),
                      Text(
                        AppStrings.dailyPractice,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    daily.sentence,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/practice'),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(AppStrings.startPractice),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Feature grid
          const Text(
            'Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _featureCard(
                emoji: '🎤',
                title: AppStrings.sttTitle,
                description: AppStrings.sttDescription,
                route: '/stt',
                color: AppColors.primary,
              ),
              _featureCard(
                emoji: '🔊',
                title: AppStrings.ttsTitle,
                description: AppStrings.ttsDescription,
                route: '/tts',
                color: AppColors.secondary,
              ),
              _featureCard(
                emoji: '📖',
                title: 'Practice',
                description: AppStrings.practiceDescription,
                route: '/practice',
                color: AppColors.success,
              ),
              _featureCard(
                emoji: '💬',
                title: 'Chat',
                description: AppStrings.conversationDescription,
                route: '/conversation',
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats row
          Consumer<HistoryProvider>(
            builder: (context, history, _) {
              final stats = history.stats;
              if (stats['totalSessions'] == 0) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Stats',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _quickStatChip(
                          '🔥 ${stats['currentStreak']} day streak',
                          AppColors.warning),
                      const SizedBox(width: 8),
                      _quickStatChip(
                          '🏆 ${((stats['bestScore'] as double) * 100).toStringAsFixed(0)}% best',
                          AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),

          // Tip card
          Card(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                  color: AppColors.primary, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text(
                        'English Tip of the Day',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.englishTips[_currentTipIndex],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard({
    required String emoji,
    required String title,
    required String description,
    required String route,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickStatChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color),
    );
  }
}

// Mini practice tab
class _PracticeTab extends StatelessWidget {
  const _PracticeTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📖', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Practice Mode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Improve your pronunciation with interactive sentence practice.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/practice'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Practice'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/conversation'),
              icon: const Icon(Icons.chat),
              label: const Text('Start Conversation'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mini history tab
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Your Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'View your practice history and track your improvement.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/history'),
              icon: const Icon(Icons.history),
              label: const Text('View History'),
            ),
          ],
        ),
      ),
    );
  }
}
