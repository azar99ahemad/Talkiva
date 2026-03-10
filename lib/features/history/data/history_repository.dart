import 'package:shared_preferences/shared_preferences.dart';
import 'models/history_entry.dart';

class HistoryRepository {
  static const String _key = 'practice_history';

  Future<void> saveEntry(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getHistory();
    existing.insert(0, entry);
    await prefs.setString(_key, HistoryEntry.encodeList(existing));
  }

  Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return HistoryEntry.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<Map<String, dynamic>> getStats() async {
    final history = await getHistory();
    if (history.isEmpty) {
      return {
        'totalSessions': 0,
        'averageScore': 0.0,
        'bestScore': 0.0,
        'currentStreak': 0,
      };
    }

    final scores = history
        .where((e) => e.score != null)
        .map((e) => e.score!)
        .toList();

    final avgScore = scores.isEmpty
        ? 0.0
        : scores.reduce((a, b) => a + b) / scores.length;
    final bestScore = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a > b ? a : b);

    // Calculate streak: count consecutive days up from today
    final now = DateTime.now();
    final dates = history
        .map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime check = DateTime(now.year, now.month, now.day);
    for (final d in dates) {
      if (d == check) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else if (d.isBefore(check)) {
        break;
      }
    }

    return {
      'totalSessions': history.length,
      'averageScore': avgScore,
      'bestScore': bestScore,
      'currentStreak': streak,
    };
  }
}
