import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'models/quest.dart';
import 'screens/add_edit_quest_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quest_detail_screen.dart';
import 'screens/quest_list_screen.dart';
import 'services/progress_service.dart';
import 'services/storage_service.dart';
import 'theme.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(
    // DevicePreview draws a phone frame around the app so it is judged at
    // the size it was designed for, instead of stretched across a laptop
    // window. See START-HERE.md for why this stays on in the deployed
    // build.
    DevicePreview(
      enabled: true,
      builder: (context) => const LifeQuestApp(),
    ),
  );
}

class LifeQuestApp extends StatelessWidget {
  const LifeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Quest',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: appTheme,
      home: const AppShell(),
    );
  }
}

/// Owns the app's shared state: the quest list, the username, and which
/// achievements have been unlocked. Every screen reads it from here and
/// calls back up here to change it, so there is a single place that talks
/// to StorageService and a single place that calls setState. This is the
/// "lift state up" pattern from Modules 4 and 5 — no external state
/// management package is used on purpose, to match where the course is at
/// when this MVP was built.
///
/// What actually changing something looks like, end to end: a screen calls
/// one of the methods below -> the in-memory list updates via setState ->
/// the change is written to StorageService -> ProgressService checks
/// whether XP, a level, or an achievement changed as a result -> the user
/// is told so with a SnackBar. No screen computes XP, levels or achievement
/// unlocks itself; they only ever display what AppShell hands them.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final StorageService _storage = StorageService();

  List<Quest> _quests = [];
  String _username = 'Adventure Seeker';
  Set<String> _unlockedAchievementIds = {};
  int _tabIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final quests = await _storage.loadQuests();
    final username = await _storage.loadUsername();
    var unlocked = await _storage.loadUnlockedAchievements();

    // Reconcile once at startup, silently (no SnackBar): this covers the
    // very first run, where the seeded sample quests already satisfy a
    // couple of achievements, and any achievement that became true while
    // the app was closed.
    final newlyTrue = ProgressService.newlyUnlocked(quests, unlocked);
    if (newlyTrue.isNotEmpty) {
      unlocked = {...unlocked, ...newlyTrue.map((a) => a.id)};
      await _storage.saveUnlockedAchievements(unlocked);
    }

    setState(() {
      _quests = quests;
      _username = username;
      _unlockedAchievementIds = unlocked;
      _loading = false;
    });
  }

  Future<void> _persistQuests() => _storage.saveQuests(_quests);

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  /// Unlocks (and persists) any achievement that just became true, and
  /// tells the user about each one. Called after every quest change.
  Future<void> _checkAchievements() async {
    final newly =
        ProgressService.newlyUnlocked(_quests, _unlockedAchievementIds);
    if (newly.isEmpty) return;

    setState(() {
      _unlockedAchievementIds = {
        ..._unlockedAchievementIds,
        ...newly.map((a) => a.id),
      };
    });
    await _storage.saveUnlockedAchievements(_unlockedAchievementIds);
    for (final achievement in newly) {
      _showSnack('🏆 Achievement unlocked: ${achievement.title}!');
    }
  }

  void _addQuest(Quest quest) {
    setState(() => _quests = [quest, ..._quests]);
    _persistQuests();
    _showSnack('Quest added: "${quest.title}".');
    _checkAchievements();
  }

  /// Handles both a plain edit and a completion (Quest Detail's "Mark
  /// Complete" calls this same callback). The two are told apart by
  /// comparing total XP before and after: only completing a quest moves it,
  /// so only that case earns the "+XP" / "Level up!" message.
  void _updateQuest(Quest updated) {
    final xpBefore = ProgressService.totalXp(_quests);
    final levelBefore = ProgressService.levelForXp(xpBefore);

    setState(() {
      _quests = _quests
          .map((q) => q.questId == updated.questId ? updated : q)
          .toList();
    });
    _persistQuests();

    final xpAfter = ProgressService.totalXp(_quests);
    final levelAfter = ProgressService.levelForXp(xpAfter);
    final xpGained = xpAfter - xpBefore;

    if (xpGained > 0) {
      var message = 'Quest completed! +$xpGained XP earned.';
      if (levelAfter > levelBefore) {
        message += ' Level up! You are now level $levelAfter.';
      }
      _showSnack(message);
    } else {
      _showSnack('Quest updated.');
    }

    _checkAchievements();
  }

  void _deleteQuest(String questId) {
    final index = _quests.indexWhere((q) => q.questId == questId);
    final title = index == -1 ? 'Quest' : _quests[index].title;

    setState(() {
      _quests = _quests.where((q) => q.questId != questId).toList();
    });
    _persistQuests();
    _showSnack('Deleted "$title".');
    // Not followed by _checkAchievements(): deleting a quest can only
    // reduce totals, never unlock a new achievement, and earned badges are
    // never revoked. See ProgressService.newlyUnlocked.
  }

  Future<void> _renameUser(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == _username) return;
    setState(() => _username = trimmed);
    await _storage.saveUsername(trimmed);
    _showSnack('Username updated to "$trimmed".');
  }

  Future<void> _openAddQuest() async {
    final result = await Navigator.push<Quest>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditQuestScreen()),
    );
    if (result != null) _addQuest(result);
  }

  void _openQuestDetail(Quest quest) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuestDetailScreen(
          quest: quest,
          onUpdate: _updateQuest,
          onDelete: _deleteQuest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = [
      DashboardScreen(
        quests: _quests,
        username: _username,
        unlockedAchievementIds: _unlockedAchievementIds,
        onSeeAllQuests: () => setState(() => _tabIndex = 1),
        onAddQuest: _openAddQuest,
        onQuestTap: _openQuestDetail,
      ),
      QuestListScreen(
        quests: _quests,
        onAddQuest: _openAddQuest,
        onQuestTap: _openQuestDetail,
      ),
      ProfileScreen(
        quests: _quests,
        username: _username,
        unlockedAchievementIds: _unlockedAchievementIds,
        onRename: _renameUser,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: screens),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
      ),
    );
  }
}
