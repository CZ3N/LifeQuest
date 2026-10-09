# Security and privacy

**Last checked:** 2026-10-09 (documentation review; update after the next technical check)

This repository is public. Do not commit real personal journal entries, credentials, tokens, or private account data.

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Quest title, category, description, status, target date, completion date, journal notes, XP reward | Local `shared_preferences` as a JSON string | User of that local browser/device profile |
| Username | Local `shared_preferences` | User of that local browser/device profile |
| Unlocked achievement IDs | Local `shared_preferences` | User of that local browser/device profile |
| XP, level, and progress totals | Calculated from local quest records | User of that local browser/device profile |

The current MVP does not send these records to a remote database. Local browser storage is not encrypted cloud storage, account synchronization, or a backup. Clearing browser/site data may remove saved information.

## Secrets

- Runtime API keys required by the current MVP: none.
- Local `.env`: not required by the current implementation.
- Deployment secrets: none are currently required by the local-only implementation.
- Values included in the deployed web build: no private API keys or service credentials are intended to be included.

## What protects the data on the service side

There is no application backend or cloud database in the current MVP, so there are no Firestore rules or Supabase RLS policies. Data is stored locally through `shared_preferences`. Anyone with access to the same unlocked device/browser profile may be able to access its local app data; do not use the app to store sensitive information.

## Checklist

- [x] `.env` is listed in `.gitignore` and `.env.example` contains no real secrets.
- [x] Current app code does not require a service credential or private API key.
- [ ] Review Git history for accidentally committed credentials before final submission.
- [x] Keep synthetic sample data only; review screenshots/video before publishing.
- [x] Do not include course/university credentials in the public repository.
- [ ] Manually verify browser persistence and review the final deployed build before submission.

Checked boxes reflect the repository/configuration review for this integration, not a substitute for remaining manual checks.
