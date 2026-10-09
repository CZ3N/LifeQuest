import 'package:flutter/material.dart';

/// The kinds of experience a quest can represent.
/// See docs/01-proposal.md, "What I Save, Concretely".
enum QuestCategory { fitness, adventure, travel, learning, personal }

/// A quest is either still open or already completed. The MVP does not
/// have an "abandoned" state — a quest the user no longer wants is deleted
/// instead of tracked as abandoned.
enum QuestStatus { active, completed }

extension QuestCategoryX on QuestCategory {
  String get label {
    switch (this) {
      case QuestCategory.fitness:
        return 'Fitness';
      case QuestCategory.adventure:
        return 'Adventure';
      case QuestCategory.travel:
        return 'Travel';
      case QuestCategory.learning:
        return 'Learning';
      case QuestCategory.personal:
        return 'Personal';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestCategory.fitness:
        return Icons.directions_run;
      case QuestCategory.adventure:
        return Icons.terrain;
      case QuestCategory.travel:
        return Icons.flight_takeoff;
      case QuestCategory.learning:
        return Icons.menu_book;
      case QuestCategory.personal:
        return Icons.self_improvement;
    }
  }

  Color get color {
    switch (this) {
      case QuestCategory.fitness:
        return const Color(0xFF2E7D32);
      case QuestCategory.adventure:
        return const Color(0xFF4FC3F7);
      case QuestCategory.travel:
        return const Color(0xFFF9A825);
      case QuestCategory.learning:
        return const Color(0xFF7E57C2);
      case QuestCategory.personal:
        return const Color(0xFFEC407A);
    }
  }
}

extension QuestStatusX on QuestStatus {
  String get label => this == QuestStatus.completed ? 'Completed' : 'Active';
}

/// A single Life Quest: something the user wants to do, is doing, or has
/// done. This is the one record type the MVP persists — see
/// docs/01-proposal.md, "My Choice" and "What I Save, Concretely".
class Quest {
  final String questId;
  String title;
  QuestCategory category;
  String description;
  QuestStatus status;
  DateTime targetDate;
  DateTime? completionDate;
  String journalNotes;
  int xpReward;

  Quest({
    required this.questId,
    required this.title,
    required this.category,
    required this.description,
    required this.targetDate,
    this.status = QuestStatus.active,
    this.completionDate,
    this.journalNotes = '',
    this.xpReward = 50,
  });

  Quest copyWith({
    String? title,
    QuestCategory? category,
    String? description,
    QuestStatus? status,
    DateTime? targetDate,
    DateTime? completionDate,
    String? journalNotes,
    int? xpReward,
  }) {
    return Quest(
      questId: questId,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      completionDate: completionDate ?? this.completionDate,
      journalNotes: journalNotes ?? this.journalNotes,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  /// Converts this quest to a JSON-safe map. Dates are stored as
  /// ISO-8601 strings because shared_preferences only stores primitives
  /// and JSON has no native date type.
  Map<String, dynamic> toJson() => {
        'questId': questId,
        'title': title,
        'category': category.name,
        'description': description,
        'status': status.name,
        'targetDate': targetDate.toIso8601String(),
        'completionDate': completionDate?.toIso8601String(),
        'journalNotes': journalNotes,
        'xpReward': xpReward,
      };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        questId: json['questId'] as String,
        title: json['title'] as String,
        category: QuestCategory.values.byName(json['category'] as String),
        description: json['description'] as String,
        status: QuestStatus.values.byName(json['status'] as String),
        targetDate: DateTime.parse(json['targetDate'] as String),
        completionDate: json['completionDate'] == null
            ? null
            : DateTime.parse(json['completionDate'] as String),
        journalNotes: json['journalNotes'] as String? ?? '',
        xpReward: json['xpReward'] as int? ?? 50,
      );
}
