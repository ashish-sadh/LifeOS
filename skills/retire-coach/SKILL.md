---
name: retire-coach
description: Cleanly archive a coach you no longer use. Moves coach folder to Archive/, removes shell alias, optionally cleans up Drive folders. Triggers on "retire [coach]" / "archive [coach]" / "remove [coach]".
---

# Skill: retire-coach

When a coach has run its course (you got better, you moved on, you tried it and didn't like it), retire it cleanly without losing history.

## When to invoke

- User: "retire the speaking coach" / "I'm done with cooking" / "archive [coach]"
- Auto-suggested by `vault-maintain` if a coach has had no sessions in 60+ days
- Confirm before acting (irreversible without manual recovery)

## What it does

1. **Confirm retirement** — show the coach's stats (last session date, total sessions, key files), ask user to confirm
2. **Archive folder locally**:
   ```bash
   mv "$VAULT/Coaches/GetBetterAt<Name>" "$VAULT/Archive/Coaches/GetBetterAt<Name>-retired-YYYY-MM"
   ```
3. **Remove shell alias** from `~/.zshrc` — find the line, remove it, alert user that new terminal tab is needed for change to take effect
4. **Update `_shared/retired-coaches.md`** with retirement note:
   ```markdown
   ## GetBetterAt<Name>
   - **Retired**: 2026-09-15
   - **Reason**: <user provides>
   - **Active period**: <start_date> to <last_session_date> (~N sessions)
   - **Archive location**: Archive/Coaches/GetBetterAt<Name>-retired-2026-09
   - **Drive folders**: still exist at <urls> — manual cleanup if desired
   ```
5. **Drive cleanup**:
   - **If Drive Desktop installed**: filesystem delete propagates to Drive (skill does this if user confirms)
   - **If connector-only**: Drive folders remain forever (cosmetic only); skill outputs Drive URLs for manual web cleanup if desired
6. **Update `Vault/.claude/drive-config.json`** to remove the coach's entry
7. **Optional**: regenerate top-level vault snapshot to reflect coach is no longer active

## Reasons to retire

The skill asks why (for the retired-coaches.md note):
- "Achieved its purpose" (great — you got what you wanted)
- "Outgrew it" (you've moved past what this coach can offer)
- "Wasn't useful" (template didn't fit, or domain wasn't actually a focus)
- "Replaced by a better coach" (mention which one)
- "Life change" (no longer relevant — moved cities, changed jobs, etc.)
- "Other" — free text

This becomes useful learning for future coach design and for re-spawning if you come back.

## Don't

- Don't retire a coach without confirmation — destructive actions need explicit OK
- Don't delete the coach folder (use `mv` to Archive/ — recoverable)
- Don't remove personal data from `Archive/` — it's still your data
- Don't propagate Drive deletes without confirmation if Drive Desktop is installed
- Don't retire a coach mid-conversation (e.g., if user is currently in `pole` session)

## Recovery (un-retire)

If you change your mind:

```bash
# Move back from archive
mv "$VAULT/Archive/Coaches/GetBetterAt<Name>-retired-2026-09" "$VAULT/Coaches/GetBetterAt<Name>"

# Re-add alias to ~/.zshrc
# Drive folders may have been cleaned up — recreate via spawn-coach if needed
# Ideally: just spawn fresh and import historical context selectively
```

The skill outputs these recovery steps when retiring.

## Why this matters

Without a clean retirement process, you accumulate dead coaches — folders, aliases, Drive entries, mental load — for things you no longer care about. A friction-free retirement keeps the system meaningful.

The Archive/ pattern means nothing is ever lost. You can come back, you can review what worked, you can extract patterns. Retirement is graceful, not destructive.
