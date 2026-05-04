---
name: vault-push-snapshot
description: Generate a comprehensive snapshot from current local canonical state and upload to Drive as a new dated file. Triggered at end of substantive coach conversations, or on user request "save", "sync to Drive", "push snapshot".
---

# Skill: vault-push-snapshot

After Mac Claude updates local canonical files (via conversation or `vault-pull-inbox` integration), generate a fresh snapshot and push to Drive. Phone reads the latest snapshot to bootstrap context.

## When to invoke

- **At end of substantive sessions** — coach `CLAUDE.md` invokes after `obsidian-sync` skill writes back updates
- **On request**: User says "save to Drive", "sync", "push snapshot"
- **After daily-consolidate** runs — keeps phone snapshot fresh after consolidation

## Skip if
- Less than 60 sec since last push (avoid redundant)
- No local canonical files have been modified since last snapshot

## Inputs

- Coach name
- `Vault/.claude/drive-config.json` — folder IDs

## Algorithm

1. Read coach's local canonical files:
   - `Coaches/<coach>/CLAUDE.md` (persona — for "Persona" section)
   - `Coaches/<coach>/profile.md` (for "Profile" section)
   - `Coaches/<coach>/program.md` (for "Current program" section)
   - `Coaches/<coach>/vocabulary.md` (full content for "Vocabulary" section — compress if very large)
   - `Coaches/<coach>/sessions.md` (last 5-10 entries for "Recent sessions" section)
   - `_shared/profile.md` (relevant excerpts for "User profile" section)
2. Compose comprehensive snapshot file (see template below)
3. Generate filename: `snapshot-<YYYY-MM-DDTHH-MM>.md` (use current Mac local time, ISO-format with hyphens for filesystem-safe)
4. Read `drive-config.json` → get coach's `snapshots_id`
5. Use Drive connector `create_file`:
   - parentId = `snapshots_id`
   - title = the filename
   - contentMimeType = `text/markdown`
   - disableConversionToGoogleType = `true`
   - textContent = composed snapshot
6. Update local marker `~/.cache/vault-last-push.json` with timestamp + uploaded file ID

## Snapshot template (compose this content)

```markdown
---
type: <coach>-coach-snapshot
generated_at: <ISO timestamp>
generator: claude-cli-mac
description: Comprehensive bootstrap context for phone Claude. Self-sufficient.
---

# <Coach> Coach — Snapshot (<date>)

## Persona — who you are
<extracted from CLAUDE.md persona section>

## User profile
<key facts from _shared/profile.md>

## <Coach>-specific profile
<full from Coaches/<coach>/profile.md, compressed if needed>

## Vocabulary
<entries from vocabulary.md — title + 1-2 sentence summary each>

## Current program
<full from program.md>

## Recent sessions
<last 5-10 from sessions.md, may be compressed>

## Open gaps / things to surface naturally
<from profile.md "gaps" section>

## Coaching priorities
<from CLAUDE.md or profile.md priorities>

## How to greet user
<example openers>

## How to write back to Drive
<instructions for phone Claude to create_file in inbox/, with filename format and content structure>

## Don't
<key prohibitions: no fake move names, don't push pain, etc.>
```

## Don't

- Don't include `_shared/profile.md` raw — extract only what's relevant to this coach's domain
- Don't include full vocabulary if >5 entries — summarize each entry in 1-2 sentences and link to the full file
- Don't push if nothing has changed locally since last push (waste of Drive files)
- Don't push to wrong coach folder — verify coach context before reading drive-config

## Why this matters

Without fresh snapshots, phone Claude bootstraps from old context. The whole "one-tap to a coach who knows you" experience depends on snapshots being current. Always push at end of substantive Mac sessions.
