import '../models/achievement.dart';
import '../models/quest.dart';
import '../utils/constants.dart';

/// Pure game-progress calculations, kept out of the widgets so the
/// Dashboard, Profile screen and AppShell can never disagree about what
/// "total XP" or "which achievements just unlocked" means. Nothing in this
/// file touches BuildContext, setState or storage — it only takes data in
/// and returns data out, which is what makes it easy to reason about (and
/// to unit test, if a test is added later).
/// See docs/01-proposal.md, "Progress Dashboard" and "Achievement System".
class ProgressService {
  ProgressService._();

  /// XP only ever comes from quests the user has actually completed.
  static int totalXp(List<Quest> quests) => quests
      .where((q) => q.status == QuestStatus.completed)
      .fold(0, (sum, q) => sum + q.xpReward);

  static int levelForXp(int xp) => (xp ~/ kXpPerLevel) + 1;

  /// How far into the current level [xp] is, for the progress bar.
  static int xpIntoLevel(int xp) => xp % kXpPerLevel;

  /// Every achievement whose condition is true right now, regardless of
  /// whether the user has already been shown it.
  static List<Achievement> currentlyUnlocked(List<Quest> quests) =>
      allAchievements.where((a) => a.isUnlocked(quests)).toList();

  /// Achievements that are true right now but are not yet in
  /// [alreadyKnown]. Used to fire a one-time "Achievement unlocked!"
  /// notification instead of re-announcing the same badge every rebuild.
  ///
  /// Achievements are permanent once earned: if a quest that helped unlock
  /// one is later edited or deleted, the badge is not revoked. It simply
  /// stops being recomputed as "currently true" — which is harmless,
  /// because by then its id is already in [alreadyKnown].
  static List<Achievement> newlyUnlocked(
    List<Quest> quests,
    Set<String> alreadyKnown,
  ) {
    return currentlyUnlocked(quests)
        .where((a) => !alreadyKnown.contains(a.id))
        .toList();
  }
}
