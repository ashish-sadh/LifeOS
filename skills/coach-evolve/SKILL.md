---
name: coach-evolve
description: Per-coach self-review. Every ~10 sessions, the coach reads its own session history and proposes content extractions, vocabulary additions, profile refinements, and structural changes. Triggers on user request "evolve this coach" or auto-suggested after threshold.
---

# Skill: coach-evolve

The coach gets better at being your coach over time. This skill is the mechanism: periodically, the coach reads its own track record and proposes how to improve.

This is Layer 2 of "the coach gets better" (Layer 1 = per-conversation extraction; Layer 3 = quarterly meta-review).

## When to invoke

- User: "evolve [coach name]" / "refine the pole coach" / "what should we restructure here?"
- Auto-suggested when sessions count crosses 10, 25, 50, 100 (configurable)
- Called by `coach-meta-review` as a substep
- After spawning a new coach, run a "lite" evolve to check basic structure makes sense

## What it does

Reads everything about the current coach:
- All `sessions.md` entries (full)
- All `vocabulary.md` entries
- `profile.md`
- `program.md`
- Last 30 inbox files (if any unprocessed)
- Any topic-specific files (`progressions/`, `recipes/`, etc.)

Then synthesizes:

### 1. Recurring themes worth extracting
- Topics mentioned 3+ times across sessions
- Patterns the user described but never named
- Insights repeated in different sessions

Proposed action: extract dedicated file in `progressions/`, `themes/`, or domain-specific folder.

Example:
> *"You've discussed shoulder mount technique across 7 sessions over 6 weeks. Cues like 'active scap depression' and 'foot placement' keep recurring. I'd extract `progressions/shoulder-mount.md` consolidating: technique cues, common failure modes, your specific failure pattern, conditioning that's helped, current week of progression. This gives us a single growing reference instead of scattered session notes."*

### 2. New vocabulary entries
- Moves/concepts mentioned in sessions but not in vocabulary.md
- Concepts where the user's understanding has deepened (update existing entries)

Proposed action: add or refine entries.

### 3. Profile refinements
- Asymmetries that became clearer (e.g., "left side" became "left external hip rotation specifically")
- New fears or favorite moves
- Body changes (recovered injury, new sensitivity)

Proposed action: targeted profile.md update.

### 4. Persona refinements based on observed user response
- Cues the user responds to vs. ignores
- Tone that works (direct vs. encouraging)
- Format preferences (bullet lists vs. prose; long vs. short)

Proposed action: edit `CLAUDE.md` Voice section to match observed effective patterns.

Example:
> *"My CLAUDE.md says 'encouraging without coddling' but my actual successful messages are 'direct, technical, brief.' Update voice section to match what actually works for you?"*

### 5. Stale or unused fields
- Tracking fields the user stopped filling in (e.g., '1-10 rating per session')
- Sections of profile.md that haven't been updated in months

Proposed action: drop or simplify the field.

### 6. Cross-coach observations
- Patterns this coach noticed that belong in another coach (or in `_shared/`)

Proposed action: surface to user; suggest mention in target coach.

## Output format

Coach-evolve produces a report:

```
## Coach Evolution Report — Pole Coach (2026-08-15, after 23 sessions)

### Themes worth extracting (1)
1. **Shoulder mount progression** — 7 sessions over 6 weeks. Extract to `progressions/shoulder-mount.md`?

### Vocabulary additions (3)
1. **Cup grip** — referenced 12 times, no entry
2. **Split grip** — added by phone Claude 2026-07-12, never refined
3. **Aysha** — mentioned twice as aspirational, no entry

### Profile refinements (2)
1. Left-side weakness now specifically: external hip rotation (was generic "left side")
2. Trap flare pattern: specifically with shoulder mount entries, not crucifix or other inverts

### Persona refinements (1)
1. Voice section says "encouraging" — actual successful sessions show direct/technical works better. Update?

### Stale fields (1)
1. "Rating 1-10" hasn't been used in 8 sessions. Drop?

### Cross-coach observations (1)
1. Sleep quality affects pole class performance. Worth tracking in fitness coach when added.

Reply with the numbers you want to apply, or "all" / "none".
```

## Applying selected items

After the user replies (e.g., "1, 3" or "all" or "just the vocabulary ones"), confirm exactly what you're about to do before writing:

> *"Applying 3 items:*
> *1. Extracting `progressions/shoulder-mount.md` from session notes*
> *2. Adding 'Cup grip' and 'Aysha' to vocabulary.md*
> *3. Updating profile.md: left-side weakness → left external hip rotation specifically*
>
> *Skipping: persona refinement (you want to think on it), stale 'Rating 1-10' field (keeping for now)*
>
> *Proceed?"*

After confirmation, apply changes. For each:
- **Theme extraction**: create the new file with structured content pulled from sessions
- **Vocabulary**: add or update entries with source sessions cited
- **Profile**: append timestamped change block, never overwrite
- **Persona**: edit CLAUDE.md Voice section, show before/after diff
- **Stale field removal**: show what you're removing, confirm before deleting

When done: regenerate snapshot via `vault-push-snapshot`.

If user says "none": acknowledge and suggest when to revisit ("come back to this after a few more sessions").

## Lite evolve (for newly spawned coaches)

Run when invoked immediately after `spawn-coach` or when session count is 1–5. Skips session-history analyses and focuses on structure only:

```
## Lite Coach Evolution — Fitness Coach (session 0, just spawned)

### Structure check
1. profile.md has "Open gaps" section with 3 items — looks good
2. No progressions/ folder yet — that's fine, create when first pattern emerges
3. CLAUDE.md "Voice" section is template default — should be personalized after 3-5 sessions

### Nothing to extract yet (< 5 sessions needed for theme detection)

Re-run this after session 5 for a full evolution report.
```

Lite evolve writes nothing — it's informational only.

## Algorithm

1. Check session count:
   - 0–5: run lite evolve (structure check only, no writes)
   - <5 for full: decline with message: "Not enough session history yet — run after 5+ sessions."
2. Read all coach files
3. Run the 6 analyses above
4. If any analysis produces zero items, omit that section
5. Cap at 8 proposed items total — drop lowest-priority if over
6. Compose the report
7. Wait for user input
8. Confirm selected items before applying
9. Apply selected items
10. After applying, regenerate snapshot via `vault-push-snapshot`
11. Update `~/.cache/vault-coach-evolve-history.json` with timestamp and what was applied

## Frequency

Default: auto-suggested every 10 sessions. After session #10, #20, #30, etc., the coach mentions evolution opportunity.

Configurable in `Coaches/<coach>/CLAUDE.md`:
```
evolve_interval_sessions: 15  # don't pester before 15 sessions
```

## Don't

- Don't run if <5 sessions exist (not enough data)
- Don't apply changes without explicit approval
- Don't rewrite the coach's voice without user input
- Don't propose more than 8 items in one report (overwhelming)
- Don't propose theme extraction unless 3+ supporting sessions
- Don't be smug ("I noticed you keep failing X"). Just observe.

## Why this matters

A static template can't be your coach. Coaches that don't refine themselves stay generic forever. The framework promises personalized coaching that compounds; this skill delivers it.
