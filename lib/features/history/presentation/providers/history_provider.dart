import 'package:flutter/foundation.dart';

import '../../data/history_repository.dart';
import '../../data/models/history_entry.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository = HistoryRepository();

  List<HistoryEntry> _entries = [];
  Map<String, dynamic> _stats = {
    'totalSessions': 0,
    'averageScore': 0.0,
    'bestScore': 0.0,
    'currentStreak': 0,
  };
  bool _isLoading = false;
  String _filterType = 'all';

  List<HistoryEntry> get entries => _entries;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String get filterType => _filterType;

  List<HistoryEntry> get filteredEntries {
    if (_filterType == 'all') return _entries;
    return _entries.where((e) => e.type == _filterType).toList();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _repository.getHistory();
    _stats = await _repository.getStats();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(HistoryEntry entry) async {
    await _repository.saveEntry(entry);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    _entries = [];
    _stats = {
      'totalSessions': 0,
      'averageScore': 0.0,
      'bestScore': 0.0,
      'currentStreak': 0,
    };
    notifyListeners();
  }

  void setFilter(String filter) {
    _filterType = filter;
    notifyListeners();
  }
}
