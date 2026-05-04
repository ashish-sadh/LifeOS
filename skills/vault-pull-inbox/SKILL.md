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

Phone Claude writes inbox files using the sections it knows from `context-snapshot.md`. The canonical format is:

```markdown
# Inbox — <coach-name> — <YYYY-MM-DDTHH-MM>

## Session log entry
<Free prose: what happened in this session. Date, key events, outcome.>

## Vocabulary additions
- **<term>**: <definition or note>
- **<term>**: <definition>

## Profile updates
- <timestamped observation about the user's state, body, goals, or constraints>

## Program adjustments
- <any change to plan, progression, or schedule discussed>

## Cross-coach observations
- <anything relevant for another coach or the vault root>
```

Not all sections appear in every file. A session that was just Q&A might only have "Session log entry." A vocabulary-heavy session might have no profile updates. Both are valid.

**Section detection**: look for `## <Section Name>` headers. Sections can appear in any order. Unknown section headers should be logged and skipped (don't discard the file).

## Malformed file handling

"Malformed" covers a range of severity. Apply this decision tree for each inbox file:

### Level 1 — parseable but incomplete (most common)

Symptom: File has some recognized sections but is missing others, or sections are present but empty.

Action: **Apply what's there, skip what's missing.** Do not treat a missing section as an error. Log which sections were present. Normal outcome.

### Level 2 — content garbled (phone keyboard artifacts)

Symptom: Content is present but has escaped markdown characters (`\*`, `\[`, `\_`), smart quotes replacing code, or excess whitespace. Common on iOS with autocorrect.

Action: **Strip common artifacts before parsing:**
- Replace `\*` → `*`, `\[` → `[`, `\_` → `_`
- Replace curly quotes (`"` `"` `'` `'`) with straight equivalents
- Collapse runs of blank lines (3+ → 2)

Then re-attempt parse at Level 1. If successful, note the cleanup in the summary to user: "Cleaned formatting artifacts from 2026-05-04T09-15-pole.md."

### Level 3 — structure unrecognizable

Symptom: No `## ` section headers found, or content is clearly not a vault inbox file (e.g., an accidental file creation, a blank file, a Drive sync temp file).

Action: **Skip the file and surface to user:**

> "Inbox file `2026-05-04T09-15-pole.md` couldn't be parsed — no recognizable sections. Skipped. Check it manually at Vault/Coaches/GetBetterAtPole/inbox/ if needed."

Mark the file ID as processed (so it doesn't re-surface on every pull). Don't attempt to apply any content.

### Level 4 — Drive read failure

Symptom: `read_file_content` returns an error (permission denied, file not found, connector timeout).

Action: **Do not mark as processed.** Log the failure:

> "Could not read inbox file `<ID>` — Drive error: <error message>. Will retry next pull."

Continue with remaining inbox files. If the same file fails 3 consecutive pulls, surface to user:

> "Inbox file `<ID>` has failed to read 3 times. It may be corrupted or deleted. Remove it from the inbox folder or check Drive permissions."

At that point, ask user whether to mark it as processed (skip permanently) or keep retrying.

### Duplicate file IDs

Symptom: The same file ID appears in the Drive listing twice (Drive sync artifact).

Action: Process once, skip the duplicate. No error needed.

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
- Don't fail silently on parsing — follow the malformed file decision tree above; always tell the user what was skipped and why
- Don't pull cross-coach (e.g., when running `pole`, only pull pole inbox)
