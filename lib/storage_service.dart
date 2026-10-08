import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quest.dart';
import '../models/sample_data.dart';

/// Local persistence for Life Quest. See docs/01-proposal.md, "My Choice":
/// the MVP uses shared_preferences because Life Quest is a single-user app
/// with a small, personal dataset. Quests are stored as one JSON-encoded
/// list under a single key; there is no cloud backend.
class StorageService {
  static const String _questsKey = 'quests';
  static const String _usernameKey = 'username';
  static const String _achievementsKey = 'unlocked_achievements';

  /// Loads every saved quest. The very first time the app runs there is
  /// nothing saved yet, so this seeds and persists a small set of
  /// synthetic sample quests instead of returning an empty list.
  Future<List<Quest>> loadQuests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_questsKey);

    if (raw == null) {
      final seeded = sampleQuests();
      await saveQuests(seeded);
      return seeded;
    }

    if (raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Quest.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Overwrites the saved quest list with [quests]. Called after every
  /// add, edit, complete or delete so the data survives an app restart.
  Future<void> saveQuests(List<Quest> quests) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(quests.map((q) => q.toJson()).toList());
    await prefs.setString(_questsKey, encoded);
  }

  Future<String> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'Adventure Seeker';
  }

  Future<void> saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, name);
  }

  /// The ids of every achievement the user has ever unlocked. This is the
  /// "achievementBadges" field from docs/01-proposal.md's User Progress
  /// model: stored explicitly, rather than recomputed from the quest list
  /// every time, so a badge stays earned even if the quest that triggered
  /// it is later edited or deleted.
  Future<Set<String>> loadUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_achievementsKey) ?? const <String>[]).toSet();
  }

  Future<void> saveUnlockedAchievements(Set<String> achievementIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_achievementsKey, achievementIds.toList());
  }
}
