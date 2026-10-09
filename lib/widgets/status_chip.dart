import 'package:flutter/material.dart';

import '../models/quest.dart';

/// A small colored label showing whether a quest is active or completed.
/// See docs/03-design-system.md, Step D.
class StatusChip extends StatelessWidget {
  final QuestStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final completed = status == QuestStatus.completed;
    final color =
        completed ? const Color(0xFF2E7D32) : const Color(0xFFF9A825);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
