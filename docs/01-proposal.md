# Proposal — Life Quest

## The problem, in one sentence

Meaningful personal goals and experiences are often scattered across notes, photos, social media, and activity apps, making it difficult to keep one record of planned quests, completed experiences, progress, achievements, and personal reflections.

## Who it is for

The primary audience is young adults and outdoor enthusiasts who pursue experiences such as hiking, running events, travel, learning a skill, and personal challenges. A secondary audience is people who want to become more active or adventurous and who find milestones, XP, and achievement badges motivating.

## Core features

1. **Quest Management:** create, view, edit, and delete quests with a title, category, description, and target date.
2. **Quest Completion and Memory Logging:** mark a quest complete, record the completion date, and write a journal note.
3. **Progress Dashboard:** view quest totals, completion progress, XP, level, and recent quests.
4. **Achievement System:** unlock and view badges based on quest activity.
5. **Search and Filter:** find quests by text, category, and active/completed status.

The approved app has five main screens: Dashboard, Quest List, Quest Detail, Add/Edit Quest, and Profile & Statistics. Add/Edit is used for both creating and editing a quest.

## Out of scope, and why

Photo storage, interactive maps, friend sharing, and social features are stretch goals, not part of the current MVP. They are excluded to keep the first implementation achievable and focused on reliable quest management, text-based memories, progress, achievements, and search.

## Data the app remembers, and where it is saved

Life Quest is a single-user app. It uses `shared_preferences` for local persistence; quest records are serialized as a JSON list under the `quests` key. The app also saves the username and unlocked achievement IDs. A quest includes `questId`, `title`, `category`, `description`, `status`, `targetDate`, `completionDate`, `journalNotes`, and `xpReward`. XP, level, quest totals, and completion progress are calculated from quest records.

The expected dataset is modest (roughly 10–30 quests per week and a few hundred over time), so a local key-value store is sufficient for the MVP. Different devices or browser profiles do not sync data.

## Risks

- **JSON serialization and persistence:** malformed saved data or schema changes can cause load errors; test saving/loading after restart.
- **Asynchronous storage:** UI state and saved state can diverge if persistence fails; verify create/edit/complete/delete flows.
- **Progress consistency:** XP, level, and badges must respond correctly to quest changes; keep calculations in the progress service.
- **Browser storage limitations:** local preferences are not a cloud backup and may be cleared.
- **Scope creep:** photo storage, maps, and social functions remain stretch goals until the MVP is stable.

## Changes since the last version

- **Proposal Version 2:** narrowed the app to five MVP features and five main screens.
- **Storage decision:** chose `shared_preferences` instead of a cloud backend because the app is single-user with a small dataset.
- **Scope control:** removed photo storage from the MVP; memories are text journal notes. Maps and friend sharing remain stretch goals.
