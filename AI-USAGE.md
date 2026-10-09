# AI Usage Log — Life Quest

AI assistance was used for planning and refining project documentation, rewriting progress reports, reviewing the design-system and mockup documentation, and integrating the supplied Flutter source into the official template. This log records the work known from the project conversations. Before submission, review each entry and replace any wording that does not match your own recollection. Do not invent commit IDs: paste the actual GitHub commit URL after pushing each corresponding change.

## 1. How I used AI

### Entry 1 — Project scope and proposal alignment
- **Tool:** ChatGPT.
- **What I asked:** Help me keep the Life Quest final project aligned with Proposal Version 2 and Design System Version 2.
- **What it provided:** A structured recap of the app purpose, target audience, five MVP features, five screens, and local-storage decision.
- **What I kept/changed:** I used the recap as a checklist and kept photo storage, maps, and social features outside the MVP because they are stretch goals.
- **Commit:** Add the real GitHub commit URL for the proposal/scope update.

### Entry 2 — Weekly progress report
- **Tool:** ChatGPT.
- **What I asked:** Rewrite my Week 1 progress report in clear student-style wording for the project repository.
- **What it provided:** A more organized version with my goal for the week and work completed.
- **What I kept/changed:** I kept the meaning of my notes and reviewed the wording so it still described the work I actually did.
- **Commit:** Add the real GitHub commit URL for the weekly-report update.

### Entry 3 — Reflection journal
- **Tool:** ChatGPT.
- **What I asked:** Help rewrite my reflection about learning Flutter UI design and the harder logic/persistence material.
- **What it provided:** A clearer reflection structure based on my notes.
- **What I kept/changed:** I used my own learning experience and adjusted the language to sound natural for a student reflection.
- **Commit:** Add the real GitHub commit URL if this reflection is included in the repository.

### Entry 4 — Mockup and design-system documentation
- **Tool:** ChatGPT.
- **What I asked:** Review the Life Quest mockup/design-system requirements and help document the approved screens, colors, typography, spacing, and reusable components.
- **What it provided:** Tables and explanations for the five screens and the design tokens/components.
- **What I kept/changed:** I kept the existing green brand direction, light-mode decision, and five-screen scope. I did not claim that original Figma exports were present when they were not in the supplied archive.
- **Commit:** Add the real GitHub commit URL for the documentation/assets update.

### Entry 5 — Template integration
- **Tool:** ChatGPT.
- **What I asked:** Integrate my supplied Life Quest Flutter code into the official `LifeQuest-main` template.
- **What it provided:** A merged project structure with the app modules, dependencies, test file, documentation, and deployment workflow retained.
- **What I kept/changed:** I kept the official template's web and GitHub Pages files and the app's local `shared_preferences` storage. I still need to run the app and verify behavior before calling it tested.
- **Commit:** Add the real GitHub commit URL for the integration commit.

### Entry 6 — Final submission review
- **Tool:** ChatGPT.
- **What I asked:** Check whether the integrated project met the AI-use badge and public-repository final-project requirements.
- **What it provided:** A gap list covering the AI log, visual assets, demo recording, test verification, and live deployment.
- **What I kept/changed:** I used the gap list to improve the documentation, add a visual design board and deployment instructions, and keep unverified deployment/test status explicit.
- **Commit:** Add the real GitHub commit URL for the final review fixes.

### Entry 7 — Flutter implementation
- **Tool:** Claude (Anthropic), agentic coding session.
- **What I asked:** Build the Life Quest Flutter app's `lib/` folder — the Quest and Achievement models, local persistence with `shared_preferences`, the progress/XP/level and achievement-unlock logic, and all five approved screens — from my Proposal v2, Design System v2 and Figma mockup.
- **What it provided:** The full `lib/` tree used in this repository: `models/`, `services/` (`storage_service.dart`, `progress_service.dart`), `screens/`, `widgets/`, `theme.dart`, `main.dart`, and `test/widget_test.dart`.
- **What I kept/changed:** This is the single largest share of AI involvement in the project, which is why it gets its own entry rather than being folded into the "template integration" step above. I reviewed it against the proposal and design system, and personally added the `night_owl` achievement in `lib/models/achievement.dart` — see "Who wrote what" below.
- **Commit:** Add the real GitHub commit URL for when this code was added.

## 2. Where the AI got it wrong or needed correction

These are concrete review findings from the integrated files. Recheck them against your final version before submission.

### Case 1 — Device Preview release-mode comment
- **What AI-assisted output said:** The `pubspec.yaml` comment said Device Preview switches off automatically in a release build.
- **What was wrong:** `lib/main.dart` sets `DevicePreview(enabled: true, ...)` without a release-mode condition, so the comment did not match the actual code.
- **What I did instead:** Updated the comment to say that the current wrapper is enabled in both debug and release builds. If release behavior should differ, the code—not just the comment—must be changed and tested.
- **Commit:** Add the real GitHub commit URL for this correction.

### Case 2 — Browser tab still used template branding
- **What AI-assisted integration left behind:** `web/index.html` used the generic title “My Final Project” and a generic course-project description.
- **What was wrong:** The browser metadata did not identify the actual Life Quest app.
- **What I did instead:** Changed the title to “Life Quest” and replaced the generic description with a short description of the app.
- **Commit:** Add the real GitHub commit URL for this correction.

### Case 3 — Incomplete AI-use record
- **What AI-assisted output initially provided:** The first `AI-USAGE.md` had one entry and left the other entries and authorship details as placeholders.
- **What was wrong:** That draft was not complete enough for the assignment's six-entry minimum and did not explain the known uses of AI across the project.
- **What I did instead:** Expanded the log with six project-related uses and concrete review findings. I still need to attach real commit URLs and verify the wording against the actual work before submission.
- **Commit:** Add the real GitHub commit URL for this documentation correction.

## 3. Who wrote what

Be accurate about authorship. AI helped with integration and documentation; that does not mean every line in `lib/` was written by AI or by me. The source archive was supplied by me for integration. I should only claim personal code authorship for files I actually implemented and can explain without relying on this document.

### My contribution
- **File:** `lib/models/achievement.dart` — added the `night_owl` achievement entry (the seventh one in the list, after `century_club`).
- **Commit:** Add the actual commit URL that shows this addition.
- **Explanation in my own words:** _[Write this yourself before presenting — you need to be able to say it without reading. Starting point: every other achievement in this file unlocks off a COUNT (complete N quests) or a CATEGORY (complete an Adventure/Travel quest). Night Owl is different — it checks WHEN a quest was completed, by reading `completionDate!.hour` and checking it's 21 or later (9 PM in 24-hour time). Explain why `completionDate` needs the `!` (it's nullable — only completed quests have one, so the condition checks `status == completed` first) and why it loops with `.any()` over the quest list rather than just checking the most recent quest.]_

The rest of `lib/` (models, services, screens, widgets) was built with Claude — see Entry 7 above. I did not write those files myself and am not claiming otherwise.

### AI-assisted part I reviewed
- **File:** `lib/services/storage_service.dart`.
- **Commit:** Add the actual integration/review commit URL.
- **What it does:** It uses `SharedPreferences` to save and load the quest list as JSON under the `quests` key. It also saves the username and unlocked achievement IDs. When no quest list exists on first launch, it stores sample quests. The UI calls this service so changes can remain available after reopening the app.
- **How I checked my understanding:** Read the load/save methods and trace the calls from `lib/main.dart`. Before claiming full verification, run the app, add or edit a synthetic quest, refresh/restart the app, and confirm the record remains. The widget test alone does not prove every persistence flow works.

## Before submitting this log

- Replace every “Add the real GitHub commit URL” line with a real URL from this repository's commit history. Do not use fake hashes.
- Confirm each entry reflects actual AI use and edit the wording if needed.
- Run `flutter analyze` and `flutter test`; record the actual results elsewhere.
- Be ready to explain the code you identify as your own.
