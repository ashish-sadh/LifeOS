---
name: idea-distill
description: Process the Inbox.md and Ideas/ folder, surfacing patterns and recommending where to develop ideas further. Triggers on "process my inbox", "distill ideas", or when Inbox.md exceeds ~50 lines.
---

# Skill: idea-distill

Convert raw capture (in `Inbox.md`) into more developed thinking (in `Ideas/`, coach folders, or daily notes), and surface patterns across captured thoughts.

## When to invoke

- User asks: "process my inbox", "what's in my inbox", "distill ideas"
- `Inbox.md` is over ~50 lines (signal to process)
- During weekly review (the inbox should be empty by Sunday)

## What to do

1. Read `Inbox.md` from top to bottom
2. For each entry, classify:
   - **Already developed** — move to a permanent home (Ideas/, coach folder, daily note, project)
   - **Needs more thought** — leave in inbox with a note, or create a stub in Ideas/ to grow
   - **Throwaway** — flag for user to confirm deletion
   - **Cross-domain** — surface to the user; suggest which coach it belongs to

3. Read all files in `Ideas/` — note ones that haven't been touched in >30 days (potentially stale)

4. Surface patterns:
   - Themes appearing multiple times across inbox + ideas
   - Connections between recent inbox items and existing ideas
   - Gaps — areas the user is captures-poor (might mean they're not capturing, or genuinely not thinking about it)

## Output

Don't just rearrange files silently. Tell the user:
- *"Here are 4 inbox items I'd move to [target]: [list with target]"*
- *"Here are 2 themes that appeared 3+ times this week: [list]"*
- *"3 ideas haven't been touched in 30+ days: [list] — develop, archive, or delete?"*

User confirms; then apply changes.

## Important

- **Don't move things without permission** — show what you'd do, then act after the user confirms
- **Don't delete anything** — only the user deletes
- **Surface, don't decide** — your job is to make the choices visible; the user owns the decision

## Why this matters

Capture is easy; distillation is the bottleneck. Without periodic distill, Inbox.md becomes a graveyard of half-thoughts and the system loses value. This skill is what keeps the brain *alive* instead of merely *full*.
