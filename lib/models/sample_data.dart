import 'quest.dart';

/// Synthetic example quests shown the first time the app runs, so the
/// Dashboard is never empty on a fresh install. This content is fictional
/// and safe to ship in a public repository — see the project's
/// SECURITY-CHECKLIST.md.
List<Quest> sampleQuests() {
  final now = DateTime.now();
  return [
    Quest(
      questId: 'sample-1',
      title: 'Morning Run',
      category: QuestCategory.fitness,
      description: '5km around the neighborhood before breakfast.',
      status: QuestStatus.completed,
      targetDate: now.subtract(const Duration(days: 2)),
      completionDate: now.subtract(const Duration(days: 2)),
      journalNotes: 'Keep moving forward.',
      xpReward: 120,
    ),
    Quest(
      questId: 'sample-2',
      title: 'Explore Waterfall',
      category: QuestCategory.adventure,
      description: 'Hike to the waterfall trail outside the city.',
      status: QuestStatus.completed,
      targetDate: now.subtract(const Duration(days: 6)),
      completionDate: now.subtract(const Duration(days: 6)),
      journalNotes: 'The trail was muddy but worth it.',
      xpReward: 250,
    ),
    Quest(
      questId: 'sample-3',
      title: 'Learn Something New',
      category: QuestCategory.learning,
      description: 'Finish the first module of an online course.',
      status: QuestStatus.active,
      targetDate: now.add(const Duration(days: 5)),
      xpReward: 80,
    ),
  ];
}
