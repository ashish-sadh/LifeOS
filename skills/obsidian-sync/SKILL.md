---
name: obsidian-sync
description: Write coaching session updates back to vault files at the end of substantive conversations. Triggers on phrases like "log this", "save this", "update my profile", or when a conversation produces durable information.
---

# Skill: obsidian-sync

When a coaching conversation produces information worth keeping, this skill writes it back to the vault.

## When to invoke

- User says "log this" / "save this" / "update my [profile / program / vocabulary]"
- Conversation contains a session report (class, open practice, conditioning) — even if user didn't explicitly ask to log
- A new move came up in conversation — add to vocabulary
- New asymmetry, fear, or body update surfaced — update profile
- Program adjustment was discussed and agreed — update program

## What to write where

| Information | Target file | Pattern |
|---|---|---|
| Session report | `Coaches/<Coach>/sessions.md` | Append new entry with today's date and the standard format |
| New move definition | `Coaches/<Coach>/vocabulary.md` | Add new entry following template at the bottom of vocabulary.md |
| Move status update | `Coaches/<Coach>/vocabulary.md` | Update the "User's status" line of existing entry |
| Profile change (asymmetry, injury, fear) | `Coaches/<Coach>/profile.md` | Update relevant section; append change note with date |
| Program change | `Coaches/<Coach>/program.md` | Update current block; note change rationale |
| Cross-coach observation | Note in conversation, suggest user mention in other coach | Don't write to other coach's files unless explicitly asked |
| Daily reflection / mood / random observation | `Daily/YYYY-MM-DD.md` | Create file if not exists; append timestamped section |

## Format conventions

### Session entry format
```markdown
## YYYY-MM-DD — [class | open practice | conditioning | other]
- **What you did**: ...
- **How it felt**: ...
- **L/R quality**: ...
- **Body**: ...
- **Wins**: ...
- **Stuck points**: ...
- **Notes for coach**: ...
```

### Vocabulary entry — see template at bottom of vocabulary.md

### Profile updates
Don't rewrite sections; append change notes:
```markdown
**[Date YYYY-MM-DD update]**: Discovered that [observation]. Going forward: [implication for training].
```

## After writing — regenerate snapshot

After updating substantive files, invoke the `snapshot-regen` skill to refresh `context-snapshot.md`. This keeps phone-Claude's view current.

## Don't

- Don't write speculative content ("user might be feeling tired") — only what user said or observed
- Don't write to `_shared/profile.md` without explicit user confirmation
- Don't delete or move existing content; append/update only
- Don't create new files unless the structure calls for it (e.g., a daily note for today)
