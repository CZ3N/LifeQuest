# Life Quest

> Life Quest is a personal quest tracker for young adults and outdoor enthusiasts who want to plan meaningful experiences, record completions, and see their progress through XP and achievements.

**Live demo:** Not deployed/verified in this package. Follow [deployment instructions](docs/DEPLOYMENT.md) and replace this line with the exact GitHub Pages URL after a successful deployment.  
**Demo video:** Not recorded yet; add `docs/demo.mp4` or a hosted link when ready.  
**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University  
**Author:** Chen Zen D. Agustin

This repository is intended to be public. It does not contain a `student.json`, credentials, or real user records.

## What it does

- Create, edit, view, complete, and delete personal quests.
- Categorize quests as Fitness, Adventure, Travel, Learning, or Personal.
- Record completion dates and journal notes.
- Earn XP, progress through levels, and unlock achievement badges.
- Search and filter quests by text, category, and status.
- Save quests, username, and unlocked achievements locally between app sessions.

## Built with

| Area | Implementation |
| --- | --- |
| Framework | Flutter / Dart |
| UI state | Flutter `StatefulWidget` and `setState` |
| Local persistence | `shared_preferences`, quests encoded as JSON |
| Responsive preview | `device_preview` |
| UI | Material 3 theme and reusable widgets |

## Running it locally

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d web-server --web-port 8080
```

Open `http://localhost:8080`. Use a Flutter/Dart SDK compatible with the constraint in `pubspec.yaml`. The app keeps `device_preview` enabled for browser review of the mobile layout.

## Environment variables

The current MVP does not require API keys or environment variables. `.env.example` is retained from the template; no `.env` file is needed.

## Privacy and secrets

Quest titles, categories, descriptions, dates, journal notes, XP values, username, and unlocked achievement IDs are stored in local browser/device preferences. The current implementation does not send these records to a cloud service. Browser storage is local to that browser profile and is not account sync or backup. Use synthetic data in screenshots and demonstrations; do not publish private journal entries or credentials.

## Project documentation

- [Proposal](docs/01-proposal.md) — problem, audience, scope, storage, risks
- [Mockup and wireframes](docs/02-mockup.md) — approved screens and navigation
- [Design system](docs/03-design-system.md) — colors, type, spacing, components
- [Weekly reports](docs/04-weekly-reports.md) — progress record
- [Demo video plan and script](docs/05-demo-video.md) — recording checklist and narration
- [Deployment guide](docs/DEPLOYMENT.md) — publish the web app to GitHub Pages
- [Security and privacy](docs/06-security-and-privacy.md) — data handling and checks
- [AI usage](AI-USAGE.md) — disclose assistance and keep accurate dated entries

## Status and next steps

The supplied Flutter implementation has been integrated into this repository. It includes the dashboard, quest list, quest detail and add/edit flow, profile/statistics, local persistence, progress calculations, achievement tracking, reusable widgets, and a widget test. Deployment and demo recording are not claimed complete.

Before submission, run `flutter pub get`, `flutter analyze`, and `flutter test`; test saving and reloading after a restart; add real screenshots and a short demo video; and update the live URL after verifying GitHub Pages.

## Credits

Packages are listed in `pubspec.yaml`. Icons use Flutter Material icons. No external image assets are required by the current MVP.

## AI use

![Built with AI assistance](https://img.shields.io/badge/built%20with-AI%20assistance-0b5fff)

AI assistance was used to help integrate the supplied Life Quest source into the course template and draft project documentation. The student must review, understand, test, and revise the result and maintain [AI-USAGE.md](AI-USAGE.md) with accurate dated entries and real commit links.

## Licence

MIT, see [LICENSE](LICENSE).
