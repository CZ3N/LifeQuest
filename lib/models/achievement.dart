import 'package:flutter/material.dart';
import 'quest.dart';

/// One unlockable Life Quest achievement. [isUnlocked] is the pure rule
/// used to detect when an achievement's condition becomes true; it is
/// evaluated by ProgressService, and the resulting set of unlocked ids is
/// persisted by StorageService so a badge, once earned, stays earned. See
/// docs/01-proposal.md, "Achievement System".
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool Function(List<Quest> quests) isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

int _completedCount(List<Quest> quests) =>
    quests.where((q) => q.status == QuestStatus.completed).length;

int _totalXp(List<Quest> quests) => quests
    .where((q) => q.status == QuestStatus.completed)
    .fold(0, (sum, q) => sum + q.xpReward);

bool _hasCompletedCategory(List<Quest> quests, QuestCategory category) =>
    quests.any(
      (q) => q.status == QuestStatus.completed && q.category == category,
    );

/// The fixed list of achievements Life Quest can unlock. Adding a new
/// achievement means adding one entry here — no other file needs to change.
final List<Achievement> allAchievements = [
  Achievement(
    id: 'first_quest',
    title: 'First Steps',
    description: 'Complete your first quest.',
    icon: Icons.star,
    isUnlocked: (quests) => _completedCount(quests) >= 1,
  ),
  Achievement(
    id: 'five_quests',
    title: 'Getting Started',
    description: 'Complete 5 quests.',
    icon: Icons.check_circle,
    isUnlocked: (quests) => _completedCount(quests) >= 5,
  ),
  Achievement(
    id: 'ten_quests',
    title: 'Quest Master',
    description: 'Complete 10 quests.',
    icon: Icons.military_tech,
    isUnlocked: (quests) => _completedCount(quests) >= 10,
  ),
  Achievement(
    id: 'explorer',
    title: 'Explorer',
    description: 'Complete an Adventure quest.',
    icon: Icons.terrain,
    isUnlocked: (quests) =>
        _hasCompletedCategory(quests, QuestCategory.adventure),
  ),
  Achievement(
    id: 'globetrotter',
    title: 'Globetrotter',
    description: 'Complete a Travel quest.',
    icon: Icons.flight_takeoff,
    isUnlocked: (quests) =>
        _hasCompletedCategory(quests, QuestCategory.travel),
  ),
  Achievement(
    id: 'century_club',
    title: 'Century Club',
    description: 'Earn 500 total XP.',
    icon: Icons.bolt,
    isUnlocked: (quests) => _totalXp(quests) >= 500,
  ),
  // Added by Chen Zen — a completion-time achievement rather than a count
  // or category one, to reward late-night progress on a quest too.
  Achievement(
    id: 'night_owl',
    title: 'Night Owl',
    description: 'Complete a quest after 9 PM.',
    icon: Icons.nightlight_round,
    isUnlocked: (quests) => quests.any((q) =>
        q.status == QuestStatus.completed &&
        q.completionDate != null &&
        q.completionDate!.hour >= 21),
  ),
];
