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
   - `Coaches/<coach>/CLAUDE.md` (persona section only)
   - `Coaches/<coach>/profile.md`
   - `Coaches/<coach>/program.md`
   - `Coaches/<coach>/vocabulary.md`
   - `Coaches/<coach>/sessions.md` (most recent 5 entries, chronologically — not "5-10", exactly 5)
   - `_shared/profile.md` (extract only cross-domain-relevant facts)
2. Compose snapshot following the template and per-section budgets below
3. **Enforce the 10 KB cap** — see "Size enforcement" below
4. Generate filename: `snapshot-<YYYY-MM-DDTHH-MM>.md` (Mac local time, hyphens for filesystem safety)
5. Read `drive-config.json` → get coach's `snapshots_id`
6. Use Drive connector `create_file`:
   - parentId = `snapshots_id`
   - title = the filename
   - contentMimeType = `text/markdown`
   - disableConversionToGoogleType = `true`
   - textContent = composed snapshot
7. Update local marker `~/.cache/vault-last-push.json` with timestamp + uploaded file ID

## Snapshot template (compose this content)

Target total: **under 10 KB** (≈ 8,000 characters). Per-section budgets are listed in brackets. A compressed section should hit its budget; do not omit sections entirely unless the source file is empty.

```markdown
---
type: <coach>-coach-snapshot
generated_at: <ISO timestamp>
generator: claude-cli-mac
description: Bootstrap context for phone Claude. Self-sufficient — phone reads this file only.
---

# <Coach> Coach — Snapshot (<YYYY-MM-DD>)

## Persona [budget: ~200 chars]
<One tight paragraph from CLAUDE.md "Persona" section. Omit the meta-commentary
("You are NOT a generic AI...") — keep only the core identity statement.>

## User profile [budget: ~400 chars]
<5-10 key facts from _shared/profile.md relevant to this coach's domain.
Do not copy the whole file. Pick: name, relevant physical/cognitive context,
schedule constraints, and anything domain-relevant. Skip what doesn't matter
for this coach (e.g., pole coach doesn't need cooking dietary notes).>

## <Coach>-specific profile [budget: ~800 chars]
<From Coaches/<coach>/profile.md. Priority order for compression:
1. Keep: current level, stated goals, known failure modes, active constraints
2. Keep: anything marked as a coaching priority or open gap
3. Trim: background history older than 6 months unless still relevant
4. Trim: the "Change log" section — omit entirely>

## Vocabulary [budget: ~1,200 chars]
<From vocabulary.md. For each entry: term + 1 sentence only.
If vocabulary has ≤ 10 entries: include all.
If 11–25 entries: include the 10 most recently added or updated.
If > 25 entries: include the 10 most recently used in sessions, note
"[N more entries in local vocabulary.md — ask user to describe if needed]".>

## Current program [budget: ~600 chars]
<From program.md. Current block name, current week, this week's focus,
and next 1-2 milestones. Omit historical completed blocks.>

## Recent sessions [budget: ~2,000 chars]
<From sessions.md — most recent 5 entries, chronologically descending.
For each: date + 2-4 sentence summary. If sessions.md has < 5 entries,
include all. Don't pad with older entries to hit 5.>

## Open gaps / things to surface naturally [budget: ~300 chars]
<From profile.md "Open gaps" or "Ongoing curiosity" section.
Bullet list only — no elaboration needed here.>

## Coaching priorities [budget: ~200 chars]
<Top 2-3 priorities, from CLAUDE.md or profile.md. Bullet list.>

## How to greet user [budget: ~150 chars]
<One example opener that references current state. Not generic.
Example: "Haven't seen you since the [last session topic] — how did [X] go?">

## How to write back to Drive [budget: ~500 chars]
<Instructions for phone Claude to write inbox files. Include exactly:>

Use Drive connector `create_file`:
- parentId: `<INBOX_FOLDER_ID>` ← real ID from drive-config.json
- title: `YYYY-MM-DDTHH-MM-<topic>.md` (use current local time)
- contentMimeType: `text/markdown`
- disableConversionToGoogleType: `true`
- textContent: structured with sections —
  ## Session log entry / ## Vocabulary additions /
  ## Profile updates / ## Program adjustments / ## Cross-coach observations
  (include only sections that have content)

## Don't [budget: ~300 chars]
<3-5 key prohibitions from CLAUDE.md "Boundaries" section.
Keep only the most important; omit generic ones already implicit.>
```

## Size enforcement

**Hard cap: 10 KB (≈ 10,000 characters).** Phone Claude has a limited system-prompt budget. Snapshots over this limit may be truncated mid-file by Claude.ai, breaking the bootstrap.

After composing the snapshot, estimate character count. If over 10 KB, apply these reductions in order — stop as soon as the snapshot fits:

1. **Sessions**: reduce from 5 entries to 3. Use 1-sentence summaries for each.
2. **Vocabulary**: reduce to the 5 most recently used terms. Add `[N terms omitted — ask user or check local vocabulary.md]`.
3. **Coach profile**: keep only the "Current level", "Goals", and "Active constraints" subsections. Drop background history, change log.
4. **Persona**: trim to 2 sentences.
5. **User profile**: reduce to 3 facts (name, most relevant physical/cognitive context, one schedule constraint).

If the snapshot is *still* over 10 KB after all five reductions, push it anyway but warn the user:

> "Snapshot is over 10 KB after compression — phone Claude may see a truncated version. Consider pruning sessions.md or vocabulary.md to reduce size."

Never omit the "How to write back to Drive" section — phone Claude needs those create_file instructions to function.

## Don't

- Don't copy `_shared/profile.md` raw into the snapshot — extract only domain-relevant facts (see "User profile" budget above)
- Don't include full vocabulary entries — always summarize to one sentence per term; apply vocabulary budget rules
- Don't push if nothing has changed locally since last push (check `~/.cache/vault-last-push.json` timestamp vs. local file mtimes)
- Don't push to wrong coach folder — verify coach name from current directory before reading drive-config
- Don't omit the "How to write back to Drive" section even when aggressively compressing — it is load-bearing

## Why this matters

Without fresh snapshots, phone Claude bootstraps from old context. The whole "one-tap to a coach who knows you" experience depends on snapshots being current. Always push at end of substantive Mac sessions.
