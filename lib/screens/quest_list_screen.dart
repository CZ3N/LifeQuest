import 'package:flutter/material.dart';

import '../models/quest.dart';
import '../theme.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/quest_card.dart';

enum _Filter { all, active, completed }

/// Browse, search and filter every saved quest. See docs/02-mockup.md,
/// Screen 2.
class QuestListScreen extends StatefulWidget {
  final List<Quest> quests;
  final VoidCallback onAddQuest;
  final ValueChanged<Quest> onQuestTap;

  const QuestListScreen({
    super.key,
    required this.quests,
    required this.onAddQuest,
    required this.onQuestTap,
  });

  @override
  State<QuestListScreen> createState() => _QuestListScreenState();
}

class _QuestListScreenState extends State<QuestListScreen> {
  String _query = '';
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = widget.quests.where((q) {
      final lowerQuery = _query.toLowerCase();
      final matchesQuery = q.title.toLowerCase().contains(lowerQuery) ||
          q.category.label.toLowerCase().contains(lowerQuery);
      final matchesFilter = switch (_filter) {
        _Filter.all => true,
        _Filter.active => q.status == QuestStatus.active,
        _Filter.completed => q.status == QuestStatus.completed,
      };
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quests'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: widget.onAddQuest),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppSearchBar(
              hint: 'Search quests...',
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _FilterChip(
                  label: 'ALL',
                  selected: _filter == _Filter.all,
                  onTap: () => setState(() => _filter = _Filter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'ACTIVE',
                  selected: _filter == _Filter.active,
                  onTap: () => setState(() => _filter = _Filter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'COMPLETED',
                  selected: _filter == _Filter.completed,
                  onTap: () => setState(() => _filter = _Filter.completed),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(
                      message: widget.quests.isEmpty
                          ? 'No quests yet. Tap + to create your first one.'
                          : 'No quests match your search or filter.',
                      icon: widget.quests.isEmpty
                          ? Icons.explore_off
                          : Icons.search_off,
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final quest = filtered[index];
                        return QuestCard(
                          quest: quest,
                          onTap: () => widget.onQuestTap(quest),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFCFD8DC)),
    );
  }
}
