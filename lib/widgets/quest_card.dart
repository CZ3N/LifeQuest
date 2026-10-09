import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme.dart';
import 'status_chip.dart';

/// A single quest summary row: icon, title, category, status and XP.
/// Used on the Dashboard and the Quest List. Purely presentational — it
/// takes data and a callback and holds no state of its own.
/// See docs/03-design-system.md, Step D.
class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onTap;

  const QuestCard({super.key, required this.quest, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = quest.category.color;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(quest.category.icon, color: color),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          quest.category.label,
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 6),
                        StatusChip(status: quest.status),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '+${quest.xpReward} XP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
