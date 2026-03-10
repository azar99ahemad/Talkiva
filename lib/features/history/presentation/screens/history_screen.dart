import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/history_provider.dart';
import '../../data/models/history_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.historyTitle,
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearDialog(context),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Stats row
              _buildStatsRow(provider.stats),

              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip(provider, 'all', AppStrings.categoryAll),
                      const SizedBox(width: 8),
                      _filterChip(provider, 'practice', 'Practice'),
                      const SizedBox(width: 8),
                      _filterChip(provider, 'conversation', 'Conversation'),
                    ],
                  ),
                ),
              ),

              // History list
              Expanded(
                child: provider.filteredEntries.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.filteredEntries.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryItem(
                              provider.filteredEntries[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statCard(
            AppStrings.totalSessions,
            '${stats['totalSessions']}',
            AppColors.primary,
          ),
          const SizedBox(width: 8),
          _statCard(
            AppStrings.avgScore,
            '${((stats['averageScore'] as double) * 100).toStringAsFixed(0)}%',
            AppColors.secondary,
          ),
          const SizedBox(width: 8),
          _statCard(
            AppStrings.bestScore,
            '${((stats['bestScore'] as double) * 100).toStringAsFixed(0)}%',
            AppColors.success,
          ),
          const SizedBox(width: 8),
          _statCard(
            AppStrings.dayStreak,
            '${stats['currentStreak']}',
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(
      HistoryProvider provider, String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: provider.filterType == value,
      onSelected: (_) => provider.setFilter(value),
    );
  }

  Widget _buildHistoryItem(HistoryEntry entry) {
    final isPractice = entry.type == 'practice';
    final score = entry.score;
    Color scoreColor = AppColors.primary;
    if (score != null) {
      if (score < 0.5) {
        scoreColor = AppColors.error;
      } else if (score < 0.8) {
        scoreColor = AppColors.warning;
      } else {
        scoreColor = AppColors.success;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPractice
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.secondary.withValues(alpha: 0.1),
          child: Text(
            isPractice ? '🎤' : '💬',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          entry.sentence,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy • HH:mm').format(entry.timestamp),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: score != null
            ? Chip(
                label: Text(
                  '${(score * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: scoreColor.withValues(alpha: 0.1),
                side: BorderSide(color: scoreColor),
                padding: EdgeInsets.zero,
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            AppStrings.noHistory,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.clearHistory),
        content: const Text(AppStrings.clearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<HistoryProvider>().clearHistory();
    }
  }
}
