---
name: vault-pull-inbox
description: At session start, pull phone-written inbox files from Drive that are newer than the most recent local-tracked sync timestamp, and integrate their contents into local canonical coach files. Triggered automatically by coach CLAUDE.md at conversation start, or on user request "refresh from Drive" / "pull from phone".
---

# Skill: vault-pull-inbox

This skill brings phone-written conversation captures into the Mac canonical vault. Phone writes append-only inbox files; this skill consolidates them into local files where Mac Claude can edit freely.

## When to invoke

- **Automatic**: At the start of any coach conversation (instructed by coach `CLAUDE.md`)
- **On request**: User says "pull from Drive", "refresh from phone", "any phone updates?"
- **Skip**: If last pull < 60 sec ago (avoid redundant calls when user runs alias twice)

## Inputs

- Coach name (from current working directory or context)
- `Vault/.claude/drive-config.json` — has Drive folder IDs per coach
- `~/.cache/vault-processed-inbox.json` — local tracker of which inbox file IDs have been processed (created on first run)

## Algorithm

1. Read `drive-config.json` → get this coach's `inbox_id`
2. Read `~/.cache/vault-processed-inbox.json` → get list of already-processed inbox file IDs (if file doesn't exist, treat as empty list)
3. Use Drive connector `search_files` with query: `parentId = '<inbox_id>'` to list all inbox files
4. Filter: keep only files whose ID is NOT in the processed list
5. Sort by `createdTime` ascending
6. For each new inbox file:
   - Use `read_file_content` to get its content
   - Parse the structured sections (Session log entry, Vocabulary, Profile updates, Program adjustments, Cross-coach observations)
   - Apply each section to the appropriate local file:
     - Session log entry → append to `Coaches/<coach>/sessions.md`
     - Vocabulary additions → add or update entry in `Coaches/<coach>/vocabulary.md`
     - Profile updates → append timestamped change to `Coaches/<coach>/profile.md`
     - Program adjustments → update relevant section of `Coaches/<coach>/program.md`
     - Cross-coach observations → append to `Inbox.md` at vault root (so user sees them)
   - Add file ID to processed list
7. Write updated processed list to `~/.cache/vault-processed-inbox.json`
8. Brief summary to user: "Pulled N inbox entries from phone: [list of dates/topics]"

## Conflict handling

If an inbox entry suggests a profile/program change that conflicts with current local state, **don't silently overwrite** — surface to user:

> "Phone session on 2026-05-04 noted that your right side may now be weaker than left for shoulder mount entries. This conflicts with current profile saying right is stronger. Update profile?"

User decides; you apply.

## File format expected (from phone Claude)

Phone Claude writes inbox files in this format (per the snapshot's instructions). Be tolerant of minor format drift — phone may not always include every section.

## State tracking

`~/.cache/vault-processed-inbox.json`:
```json
{
  "version": 1,
  "last_pull": "2026-05-04T08:15:00Z",
  "processed_ids": {
    "pole": [
      "1abc...", "1def..."
    ],
    "thinking": []
  }
}
```

## Don't

- Don't process the same inbox file twice (use the ID list)
- Don't delete inbox files from Drive (connector can't anyway)
- Don't fail silently on parsing — if a phone file is malformed, surface it to user
- Don't pull cross-coach (e.g., when running `pole`, only pull pole inbox)
