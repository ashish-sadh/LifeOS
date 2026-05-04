---
name: vault-maintain
description: Periodic structural cleanup. Detects when files are too large, themes are emerging, or content is stale, and proposes restructuring. Triggers on user request "maintain the vault" / "clean up", or auto-suggested when last maintenance > 7 days. Always proposes before acting.
---

# Skill: vault-maintain

Keeps the vault fast and meaningful as it grows. Detects accumulating issues, proposes restructurings, executes after user approval. Never silent.

## When to invoke

- User says: "maintain the vault" / "clean up" / "restructure" / "vault audit"
- Auto-suggested at session start if `~/.cache/vault-last-maintenance.json` shows >7 days since last maintenance
- Called by `weekly-review` skill as part of Sunday review
- After major events (e.g., spawning a new coach, archiving old data)

## What gets checked

The skill scans for these triggers:

| Trigger | Threshold | Proposed action |
|---|---|---|
| Unprocessed inbox files in Drive | >0 | Run `vault-pull-inbox` |
| >3 inbox entries today, day not yet consolidated | end of day | Run `daily-consolidate` |
| `sessions.md` line count | >60 entries (configurable) | Archive oldest quarter to `sessions/<quarter>.md` |
| `vocabulary.md` entries | >25 (configurable) | Propose split by category |
| Repeated topic in inbox/sessions | 3+ entries on same theme over 4 weeks | Propose dedicated file (e.g., `progressions/<topic>.md`) |
| Latest snapshot age | >30 days | Force regenerate via `vault-push-snapshot` |
| Drive inbox folder file count | >50 per coach | Suggest manual cleanup via Drive web (or filesystem delete if Drive Desktop installed) |
| Open profile gaps | unfilled >14 days | Resurface to user during conversation |
| Daily/ entries | untouched >30 days | Suggest archive to `Archive/Daily/<year>/` |
| Stale ideas | files in `Ideas/` untouched >90 days | List and ask user: develop, archive, or delete |
| Stale projects | files in `Projects/` with no recent activity | List and ask |
| Coach without sessions in 60+ days | inactive | Suggest retire (call `retire-coach`) |
| Snapshot file size | >10 KB | Compress (older sessions → titles only; vocab → category list) |

## Algorithm

1. Read `~/.cache/vault-last-maintenance.json` — if exists, get last_run timestamp; otherwise treat as "never run"
2. Walk vault directory and collect metrics for each coach + vault root
3. Run all the trigger checks above
4. Compose a proposal report:
   ```
   ## Vault Maintenance Report (2026-05-15)

   Last maintenance: 9 days ago.

   ### Recommended actions

   1. [vault-pull-inbox] 3 unprocessed phone inbox files for pole — integrate now?
   2. [archive-sessions] sessions.md has 67 entries — archive Q1 (2026-01..2026-03)?
   3. [extract-progression] You've mentioned "shoulder mount" 5 times in last 3 weeks — extract to progressions/shoulder-mount.md?
   4. [split-vocab] vocabulary.md has 28 entries — split into vocab/inverts.md, vocab/holds.md, vocab/grips.md?
   5. [resurface-gap] Profile gap "specific 6-month wishlist moves" has been unfilled 27 days — surface to user?

   ### Skipped
   - Snapshot is 14 days old (regenerate threshold = 30 days) — OK
   - Drive inbox at 12 files (threshold = 50) — OK

   Reply with the numbers you want to apply (e.g., "1, 2, 4" or "all"), or "no" to skip.
   ```
5. Wait for user response
6. Apply selected actions
7. Update `~/.cache/vault-last-maintenance.json` with current timestamp + actions taken
8. Brief summary: "Applied N actions. Vault is at X files / Y MB. Next maintenance in 7 days."

## Per-action implementations

### archive-sessions
- Read sessions.md, parse entries by date
- Determine target archive (oldest quarter)
- Write `Coaches/<coach>/sessions/<YYYY-Qn>.md` with archived entries
- Rewrite sessions.md without those entries
- Update wikilinks in vocabulary.md/profile.md if any reference archived entries

### split-vocab
- Read vocabulary.md, parse entries
- Categorize (use entry headers or ask user to confirm categories)
- Write `Coaches/<coach>/vocab/<category>.md` files
- Replace vocabulary.md with index of categories
- Update CLAUDE.md to read vocab/<category>.md as needed

### extract-progression
- Find all sessions/inbox entries mentioning the topic
- Synthesize a progression narrative
- Write `Coaches/<coach>/progressions/<topic>.md`
- Add wikilink from vocabulary.md

### resurface-gap
- Note gap in current conversation: "Quick housekeeping question while we're here..."
- After 14 days, becomes more direct
- Marks gap as "surfaced" in profile.md

### compress-snapshot
- Re-run `vault-push-snapshot` skill with smaller summary mode
- Older sessions become titles-only
- Vocabulary becomes category list (link to full files)
- Stays under 10 KB

## Inputs

- All vault files (read-heavy)
- `~/.cache/vault-last-maintenance.json`
- `~/.cache/vault-processed-inbox.json`
- `Vault/.claude/drive-config.json`

## Outputs

- Proposed actions list (always shown to user first)
- Applied changes to vault files (after approval)
- Updated `~/.cache/vault-last-maintenance.json`

## Don't

- Don't apply changes without user confirmation
- Don't moralize ("you've been slacking on cleanup")
- Don't aggregate restructurings into one massive batch — keep each independently approvable
- Don't create new structure types without user input (e.g., don't invent a `progressions/` folder if user hasn't seen it)
- Don't run for inactive coaches (no sessions in 60 days) — suggest retire instead

## Configuration

Thresholds can be overridden in `Vault/.claude/maintain-config.json`:

```json
{
  "sessions_archive_threshold": 60,
  "vocab_split_threshold": 25,
  "snapshot_max_kb": 10,
  "snapshot_age_force_regen_days": 30,
  "inbox_drive_cleanup_threshold": 50,
  "auto_suggest_after_days": 7
}
```

## Why this matters

Without maintenance, the vault drifts:
- Sessions.md becomes unreadable
- Snapshots bloat → phone reads slow
- Themes hide in scattered inbox files
- Patterns go unrecognized
- Stale notes linger

Vault-maintain is the system's immune response. Run it weekly and the system stays sharp.
