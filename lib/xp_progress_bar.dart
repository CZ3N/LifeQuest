import 'package:flutter/material.dart';

/// Shows how far the user is into the current level as a labelled linear
/// progress bar. currentXp and requiredXp describe progress within the
/// current level only, not the user's lifetime total.
/// See docs/03-design-system.md, Step D.
class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int requiredXp;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.requiredXp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio =
        requiredXp == 0 ? 0.0 : (currentXp / requiredXp).clamp(0.0, 1.0);
    final remaining = (requiredXp - currentXp).clamp(0, requiredXp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 7,
            backgroundColor: const Color(0xFFE0E0E0),
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$remaining XP to next level',
          style: theme.textTheme.labelSmall
              ?.copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
