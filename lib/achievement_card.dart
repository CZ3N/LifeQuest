import 'package:flutter/material.dart';

/// One achievement badge. Locked achievements are shown greyed out with a
/// question mark so the user knows there is still something to unlock.
/// See docs/03-design-system.md, Step D.
class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const AchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.unlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = unlocked ? theme.colorScheme.primary : Colors.grey;

    return Tooltip(
      message: description,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              unlocked ? icon : Icons.help_outline,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
