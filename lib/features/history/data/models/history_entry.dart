import 'dart:convert';

class HistoryEntry {
  final String id;
  final String type; // 'practice' or 'conversation'
  final String sentence;
  final String spokenText;
  final double? score;
  final DateTime timestamp;

  const HistoryEntry({
    required this.id,
    required this.type,
    required this.sentence,
    required this.spokenText,
    this.score,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'sentence': sentence,
        'spokenText': spokenText,
        'score': score,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: json['id'] as String,
        type: json['type'] as String,
        sentence: json['sentence'] as String,
        spokenText: json['spokenText'] as String,
        score: json['score'] != null ? (json['score'] as num).toDouble() : null,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  static String encodeList(List<HistoryEntry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());

  static List<HistoryEntry> decodeList(String source) {
    final list = jsonDecode(source) as List;
    return list
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
