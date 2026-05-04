# The append-only constraint

A deep dive on why Drive-based sync uses an append-only pattern, even though it looks like a workaround.

---

## The constraint

The Google Drive connector that Claude.ai (and Claude Code via `/mcp`) use exposes these tools:

- ✅ `create_file` — make a new file
- ✅ `copy_file` — duplicate a file
- ✅ `read_file_content` / `download_file_content` — get content
- ✅ `search_files` / `list_recent_files` / `get_file_metadata` — discover files
- ❌ `update_file` — does not exist
- ❌ `delete_file` — does not exist
- ❌ `move_file` — does not exist (copy + can't-delete-original = duplicate, not move)
- ❌ `rename_file` — does not exist

In practice, this means Claude can write *new* files but cannot modify or delete *existing* files in your Drive.

## Why Anthropic shipped it this way

Best guess (not authoritative): minimum scope for safety. A read-only + create-only Drive integration is much safer than full read-write-delete. If Claude is misled by injected content or buggy, the worst case is a few extra files in your Drive. With delete enabled, the worst case is data loss.

This may evolve. If `update_file` or `delete_file` ship in future versions of the connector, much of what follows can be simplified.

## The architectural consequence

Two-way sync via the connector alone is structurally impossible without duplicates. Specifically:

**Bad pattern**: phone Claude tries to update `sessions.md` with a new entry.
- Phone calls `create_file` with title "sessions.md"
- Drive happily creates a duplicate (different ID, same name)
- Now there are two `sessions.md` files
- Repeat across N sessions → chaos

**The fix**: append-only. Phone never tries to update; phone always creates new dated files. Mac (which has full filesystem access to local canonical files) integrates them.

## The design

```
Phone Claude (create-only via connector):
  → writes to Vault/<coach>/inbox/YYYY-MM-DDTHH-MM-<topic>.md

Mac Claude (full local filesystem access):
  ← reads inbox files via connector
  ← integrates into local canonical files (sessions.md, vocabulary.md, etc.)
  → uploads new dated snapshot via connector

Phone Claude bootstrap:
  ← reads latest snapshot via connector (sort by createdTime desc)
```

Every operation is "create new file." Old files persist in Drive forever (or until manual cleanup via web UI). With Drive Desktop installed, Mac can delete old inbox files via filesystem, propagating to Drive.

## What accumulates and how much

Per active coach, per day of typical use:
- 1-3 phone inbox entries
- 1-2 Mac snapshots
- 1 daily consolidation file (after `daily-consolidate` runs)

Per year of 5 active coaches: ~3,000-10,000 files. Total size: well under 100 MB. Drive's 15 GB free tier handles this for ~50 years.

The accumulation is cosmetic, not functional. The system reads the *latest* of everything; old files are history.

## When the constraint bites you

It doesn't, much. The append-only pattern is a clean fit for coaching:
- Sessions ARE inherently append-only ("here's what I did today" never overwrites yesterday)
- Snapshots ARE inherently regenerated ("here's the current state")
- Vocabulary entries CAN grow but rarely change drastically (split into category files when too big)

The places it would bite:
- ❌ "Editing a recipe" — you'd want to update `recipes/kale-pasta.md` after refining the recipe. Connector can't. Workaround: push versioned recipes (`kale-pasta-v2.md`) and have phone read the latest. Or install Drive Desktop and edit locally.
- ❌ "Renaming a coach" — say you want `GetBetterAtCooking` → `GetBetterAtKitchen`. Drive folders persist with old names. Mitigation: spawn new, retire old, manual Drive cleanup.

For these, **install Drive Desktop**. Mac filesystem operations propagate to Drive cloud, giving you true update/delete/rename.

## The mental model that makes this OK

Think of Drive as **a logbook**, not a workspace.

- **Logbook** entries get added forever; old entries stay; you read the latest. Perfect fit for append-only.
- **Workspace** files get edited, renamed, deleted. Not what the connector supports.

Mac is the workspace (filesystem). Drive is the logbook (connector). The two stay in sync via:
- Mac → Drive: snapshot pushes (new logbook entry summarizing current workspace state)
- Drive → Mac: inbox pulls (Mac reads phone-written logbook entries, integrates into workspace)

This split is actually elegant once you accept it.

## When to NOT use this pattern

If your domain genuinely needs in-place updates (collaborative documents, version-controlled code, real-time shared state), the append-only pattern is wrong. Use Git, Notion, or a real database.

For a personal coaching system where the source of truth is markdown files on your Mac and you want phone access, append-only is the right fit.

## How Drive Desktop changes things

With Drive Desktop installed, Mac filesystem operations propagate to Drive cloud bidirectionally. The append-only constraint *only* applies to phone Claude's connector writes. Mac can:

- Update files (filesystem operation propagates to Drive)
- Delete files (filesystem deletion propagates to Drive)
- Rename / move (filesystem ops propagate)
- Restructure (Mac creates new folders, deletes old; Drive mirrors)

Phone is still create-only. But Mac's full read-write access to the same Drive folder means cleanup is automatic over time. **Recommend Drive Desktop unless you have a specific reason not to.**

## The broader lesson

Constraints can be features. Append-only history is a useful property even when not forced — it's how Git, event-sourced architectures, and good audit logs work. The Drive connector accidentally pushed us to a pattern that's clean and durable.

If `update_file` ships tomorrow, we'd probably keep the append-only pattern for inbox/snapshots anyway, and just optionally use update for canonical file edits from phone.
