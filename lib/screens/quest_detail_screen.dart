import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_chip.dart';
import 'add_edit_quest_screen.dart';

/// Full information for one quest, plus the actions that change it: edit,
/// delete and mark complete. See docs/02-mockup.md, Screen 3.
class QuestDetailScreen extends StatefulWidget {
  final Quest quest;
  final ValueChanged<Quest> onUpdate;
  final ValueChanged<String> onDelete;

  const QuestDetailScreen({
    super.key,
    required this.quest,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  late Quest _quest;

  @override
  void initState() {
    super.initState();
    _quest = widget.quest;
  }

  Future<void> _editQuest() async {
    final result = await Navigator.push<Quest>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditQuestScreen(existingQuest: _quest),
      ),
    );
    if (result != null) {
      widget.onUpdate(result);
      setState(() => _quest = result);
    }
  }

  Future<void> _deleteQuest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete quest?'),
        content: Text('"${_quest.title}" will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'DELETE',
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onDelete(_quest.questId);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _markComplete() async {
    final notesController = TextEditingController();
    DateTime completionDate = DateTime.now();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete "${_quest.title}"',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(formatDate(completionDate)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: completionDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setSheetState(() => completionDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Journal note',
                      hintText: 'What happened? How did it go?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: 'MARK COMPLETE',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == true) {
      final updated = _quest.copyWith(
        status: QuestStatus.completed,
        completionDate: completionDate,
        journalNotes: notesController.text.trim().isEmpty
            ? _quest.journalNotes
            : notesController.text.trim(),
      );
      widget.onUpdate(updated);
      setState(() => _quest = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = _quest.status == QuestStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(_quest.title),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteQuest,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Chip(
                label: Text(_quest.category.label.toUpperCase()),
                backgroundColor:
                    _quest.category.color.withValues(alpha: 0.12),
                labelStyle: TextStyle(
                  color: _quest.category.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(status: _quest.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_quest.description.isNotEmpty) ...[
            Text(
              'DESCRIPTION',
              style:
                  theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(_quest.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
          ],
          Row(
            children: [
              Expanded(
                child: _InfoBlock(
                  label: 'TARGET DATE',
                  value: formatDate(_quest.targetDate),
                ),
              ),
              Expanded(
                child: _InfoBlock(
                  label: 'REWARD',
                  value: '+${_quest.xpReward} XP',
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (completed) ...[
            const SizedBox(height: AppSpacing.md),
            _InfoBlock(
              label: 'COMPLETED ON',
              value: _quest.completionDate != null
                  ? formatDate(_quest.completionDate!)
                  : '—',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'JOURNAL NOTE',
              style:
                  theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              _quest.journalNotes.isEmpty
                  ? 'No note was added.'
                  : _quest.journalNotes,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(label: 'EDIT', onPressed: _editQuest),
              ),
              if (!completed) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _markComplete,
                    child: const Text('MARK COMPLETE'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoBlock({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}
