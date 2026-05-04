---
name: daily-consolidate
description: At end of day (or weekly review), synthesize the day's inbox entries and conversations into one consolidated day file per coach, push to Drive. Reduces inbox clutter and creates a clean per-day historical record.
---

# Skill: daily-consolidate

Multiple phone conversations per day generate multiple inbox entries. This skill consolidates them into one clean day file per coach, providing a coherent narrative of "what happened today" without forcing future Claude to read 7 small inbox files.

## When to invoke

- **User-triggered**: "consolidate today", "day review", "wrap up today" via `brain` alias or any coach
- **Implicit cadence**: At the end of each evening session (Mac coach CLAUDE.md may suggest if many inbox entries exist for today)
- **Weekly-review skill**: Calls this for each day in the past week

## Inputs

- Date to consolidate (default: today)
- `Vault/.claude/drive-config.json` — folder IDs

## Algorithm

For each coach with activity today:

1. Use Drive `search_files` with query `parentId = '<coach_inbox_id>' and createdTime > '<date>T00:00:00Z' and createdTime < '<date+1>T00:00:00Z'`
2. Read each matching inbox file
3. Synthesize a single-coach day file:
   - Group by topic (class, conditioning, reflection, etc.)
   - Compress repetition (if same topic appears 3 times, merge)
   - Surface cross-day patterns (only if obvious from this day's entries)
4. Upload to Drive `<coach>/days/YYYY-MM-DD.md` with `create_file`
5. Also write a local copy at `Coaches/<coach>/days/YYYY-MM-DD.md` (creates Mac-side cache)

## Day file template

```markdown
---
type: <coach>-day-summary
date: YYYY-MM-DD
inbox_entries_consolidated: <list of inbox file IDs source>
---

# <Coach> — <date>

## Sessions / activities today
<grouped, compressed)

## Body / energy / mood
<patterns from entries>

## Wins
<bullet list>

## Stuck points / red flags
<bullet list>

## Action for next session
<concrete bullets, max 3>

## Notable quotes / observations
<select 1-3 vivid moments>
```

## After running

- Note in user-facing response: "Consolidated N inbox entries from <date> into a day file."
- Suggest: "Want me to run snapshot regeneration to push fresh context to phone?"

## Don't

- Don't delete inbox files (connector can't; they accumulate, that's fine)
- Don't moralize ("you skipped a day, you should...")
- Don't manufacture themes if the day was quiet
- Don't run for future dates or dates with no inbox entries
- Don't run for the current day if it's still active (under 18:00, e.g.) — wait for end-of-day signal

## Why this matters

Without consolidation, the inbox grows unboundedly and phone Claude has to read many small files. Consolidation gives:
- One file per day per coach = clean history
- Less cognitive load when reviewing
- Inbox stays scoped to "untriaged" rather than "everything ever"
