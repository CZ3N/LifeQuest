import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import '../widgets/primary_button.dart';

/// One form for both creating and editing a quest. If [existingQuest] is
/// null this is "Add Quest"; otherwise it is "Edit Quest" and the form
/// starts pre-filled. Either way it pops with the finished Quest, or with
/// nothing if the user cancels. See docs/02-mockup.md, Screen 4.
class AddEditQuestScreen extends StatefulWidget {
  final Quest? existingQuest;

  const AddEditQuestScreen({super.key, this.existingQuest});

  @override
  State<AddEditQuestScreen> createState() => _AddEditQuestScreenState();
}

class _AddEditQuestScreenState extends State<AddEditQuestScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _xpController;
  late QuestCategory _category;
  late DateTime _targetDate;

  bool get _isEditing => widget.existingQuest != null;

  @override
  void initState() {
    super.initState();
    final quest = widget.existingQuest;
    _titleController = TextEditingController(text: quest?.title ?? '');
    _descriptionController =
        TextEditingController(text: quest?.description ?? '');
    _xpController = TextEditingController(text: '${quest?.xpReward ?? 50}');
    _category = quest?.category ?? QuestCategory.personal;
    _targetDate = quest?.targetDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _xpController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final quest = Quest(
      questId: widget.existingQuest?.questId ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _category,
      description: _descriptionController.text.trim(),
      status: widget.existingQuest?.status ?? QuestStatus.active,
      targetDate: _targetDate,
      completionDate: widget.existingQuest?.completionDate,
      journalNotes: widget.existingQuest?.journalNotes ?? '',
      xpReward: int.tryParse(_xpController.text) ?? 50,
    );

    Navigator.pop(context, quest);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Quest' : 'Add Quest'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('QUEST TITLE', style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter quest title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Title is required'
                      : null,
            ),
            const SizedBox(height: AppSpacing.md),

            Text('CATEGORY', style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            DropdownButtonFormField<QuestCategory>(
              value: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: QuestCategory.values
                  .map(
                    (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),

            Text('DESCRIPTION', style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe your quest...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text('TARGET DATE', style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(formatDate(_targetDate)),
              onPressed: _pickTargetDate,
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Text('XP REWARD', style: theme.textTheme.labelSmall),
            const SizedBox(height: 6),
            TextFormField(
              controller: _xpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixText: 'XP',
              ),
              validator: (value) {
                final n = int.tryParse(value ?? '');
                if (n == null || n <= 0) return 'Enter a positive number';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            PrimaryButton(label: 'SAVE QUEST', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
