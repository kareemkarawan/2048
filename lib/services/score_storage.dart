import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const String _scoresKey = 'top_scores';

  static Future<List<int>> getTopScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = prefs.getStringList(_scoresKey) ?? [];
    return scores.map(int.parse).toList();
  }

  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> scores = await getTopScores();
    scores.add(score);
    scores.sort((a, b) => b.compareTo(a));

    if (scores.length > 5) {
      scores = scores.sublist(0, 5);
    }

    await prefs.setStringList(
      _scoresKey,
      scores.map((score) => score.toString()).toList(),
    );
  }
}
