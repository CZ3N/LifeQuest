# Weekly reports

These entries summarize the progress known from project notes and the supplied code. Update dates, hours, and reflections to match your actual work before submission. Do not claim tests or deployment are complete unless you ran them.

---

## Week 1 — Planning to development

**Goal this week**

Move Life Quest from planning and design into actual development while following Proposal Version 2 and Design System Version 2 rather than adding unnecessary features.

**Done this week**

- Reviewed the official final-project GitHub template and its documentation requirements.
- Rechecked the five approved MVP features and five main screens.
- Confirmed local storage with `shared_preferences` instead of Firebase because the MVP is a single-user app.
- Planned folders for models, screens, reusable widgets, theme, and storage.
- Identified quests, completion information, journal entries, XP, and progress as the main app data.

**In progress**

- Connecting the planned architecture to a working Flutter implementation.
- Keeping documentation aligned with the proposal and design system.

**Blocked or stuck on**

Persistence and coordinating stored data with progress/achievement calculations need careful testing.

**Decisions made, and why**

- Keep journal notes as text; leave photo storage, maps, and friend sharing as stretch goals.
- Keep `device_preview` for browser review of the mobile layout.

**Hours spent, roughly:** _Fill in actual hours._

**Next week I will:** finish core screen flows, connect local persistence, and test the MVP.

---

## Week 2 — Core implementation integration

**Done this week**

- Integrated the supplied Life Quest Flutter source into the official `LifeQuest-main` repository structure.
- Added screens, models, services, theme, utility files, and reusable widgets from the implementation archive.
- Updated dependencies to include `shared_preferences` while retaining the template package name and web/deployment files.
- Updated the widget test import to match the repository package name.
- Replaced documentation placeholders with Life Quest-specific information and implementation notes.

**In progress**

- Running dependency resolution, static analysis, widget tests, and manual browser checks.
- Verifying that quests remain saved after app restart and that XP/achievement changes behave correctly.

**Blocked or stuck on**

The integration still needs validation in a Flutter-enabled environment. The supplied archives did not include mockup/wireframe exports, screenshots, or a demo recording.

**Decisions made, and why**

- Kept the template's repository/deployment configuration and package name for the existing GitHub Pages workflow.
- Did not invent a live demo URL, screenshots, video, actual hours, or commit links.

**Hours spent, roughly:** _Fill in actual hours._

**Next week I will:** run all checks, fix issues found, capture real screenshots, and record a short demo after verifying core flows.
