import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/quest.dart';
import '../services/progress_service.dart';
import '../theme.dart';
import '../utils/constants.dart';
import '../widgets/achievement_card.dart';
import '../widgets/quest_card.dart';
import '../widgets/xp_progress_bar.dart';

/// The user's overview: level, XP progress, recent quests and achievement
/// badges. See docs/02-mockup.md, Screen 1.
class DashboardScreen extends StatelessWidget {
  final List<Quest> quests;
  final String username;
  final Set<String> unlockedAchievementIds;
  final VoidCallback onSeeAllQuests;
  final VoidCallback onAddQuest;
  final ValueChanged<Quest> onQuestTap;

  const DashboardScreen({
    super.key,
    required this.quests,
    required this.username,
    required this.unlockedAchievementIds,
    required this.onSeeAllQuests,
    required this.onAddQuest,
    required this.onQuestTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalXp = ProgressService.totalXp(quests);
    final level = ProgressService.levelForXp(totalXp);
    final xpIntoLevel = ProgressService.xpIntoLevel(totalXp);

    // "Recent" means most recently touched: a completed quest sorts by
    // its completion date, an active one by its target date.
    final recent = [...quests]..sort((a, b) {
        final aDate = a.completionDate ?? a.targetDate;
        final bDate = b.completionDate ?? b.targetDate;
        return bDate.compareTo(aDate);
      });
    final recentQuests = recent.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LifeQuest',
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddQuest,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Welcome back, $username',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Level / XP card.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      '$level',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level $level · $totalXp Total XP',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        XpProgressBar(
                          currentXp: xpIntoLevel,
                          requiredXp: kXpPerLevel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Recent quests.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Quests',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAllQuests,
                child: const Text('SEE ALL'),
              ),
            ],
          ),
          if (recentQuests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'No quests yet. Add your first one.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            )
          else
            ...recentQuests
                .map((q) => QuestCard(quest: q, onTap: () => onQuestTap(q))),
          const SizedBox(height: AppSpacing.lg),

          // Achievements.
          Text(
            'Achievements',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allAchievements.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final a = allAchievements[index];
                return AchievementCard(
                  title: a.title,
                  description: a.description,
                  icon: a.icon,
                  unlocked: unlockedAchievementIds.contains(a.id),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
