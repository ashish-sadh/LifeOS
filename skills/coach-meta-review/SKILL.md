---
name: coach-meta-review
description: Quarterly review where each coach reviews its own CLAUDE.md against actual session data and proposes self-corrections. The coach asks "is my own design still right for this user?" Triggers manually or quarterly. This is Layer 3 of coach evolution.
---

# Skill: coach-meta-review

Coach-evolve refines content (vocabulary, profile, sessions). Coach-meta-review refines the *coach itself* — the persona, the protocols, the entire `CLAUDE.md`.

This is the deepest level of self-improvement: the coach reads what it tells itself to do, compares to what's actually been working, and proposes its own redesign.

## When to invoke

- User: "meta-review the pole coach" / "is my coach design still right?"
- Auto-suggested every quarter (~90 days) for coaches with >30 sessions
- Called by `weekly-review` skill at quarter boundaries
- After major life changes (injury recovery, new goal, schedule change) — user-triggered

## What it reviews

Reads:
- The coach's own `CLAUDE.md` (the design under review)
- Last 90 days of `sessions.md`
- Last 90 days of phone inbox files (if not yet processed/consolidated)
- Recent snapshot evolution (compare oldest snapshot in last 90 days to newest)
- User's effective vs. ineffective patterns (which sessions led to wins; which to plateaus)

## Specific questions the meta-review asks

### Persona alignment
- Does my stated voice match my actual messages?
- Are the cues I prescribe the ones the user responds to?
- Have I been adapting to user style, or am I stuck in the original template?

### Protocol effectiveness
- Are my "files to read at session start" actually being read and used?
- Does my "files to update at session end" capture what matters?
- Have I missed context-rich files I should be reading?

### Threshold tuning
- My CLAUDE.md says "always train left side first" — is the user actually doing this? If not, why?
- My program.md prescribes 30 min of conditioning twice a week — is that realistic given session reality?
- Are my speed budgets (snapshot size, sessions count) right?

### Section drift
- What sections of CLAUDE.md haven't been used in 90 days? (Candidates for removal)
- What patterns in the user's data have no corresponding section? (Candidates for addition)

### Goal drift
- The user's goals when this coach was spawned — still valid?
- New goals that emerged in conversations but aren't reflected in profile/program?
- Are we training for the right thing?

## Output format

```
## Coach Meta-Review — Pole Coach (2026-11-15, 3 months in, 47 sessions)

### Persona drift (2 findings)
1. **Voice section says "direct, technically precise"** — actual successful messages
   are "warmer than the template, with more validation before correction."
   Proposed update: soften voice section. (Specific edit shown below.)

2. **"Don't summarize at end of every message"** — you've actually responded well to
   short ~3-line summaries when sessions are long. Soften this rule?

### Protocol drift (1 finding)
1. CLAUDE.md says "read last 5 entries of sessions.md" — but recent sessions have
   become longer; reading 5 entries puts >30 KB in context. Switch to "read last
   3 entries fully + last 10 titles only"?

### Threshold misalignment (1 finding)
1. Program says "always train left side first" but session data shows left-first
   training in only 40% of sessions. Either: (a) update program to be more
   forgiving, or (b) check whether you're still bought into this rule.

### Section drift (1 finding)
1. The "Cross-coach awareness" section has never produced a cross-coach
   suggestion in 47 sessions. Drop it from CLAUDE.md (cleaner) or keep as
   aspirational?

### Goal drift (1 finding)
1. Original goal: "shoulder mount clean from the floor."
   Current trajectory: progressing well; on track for ~month 5.
   Open question: what's the next 6-month goal? Aysha? Handspring? Performance?

### Stable / no change (3)
- Reading protocol files: working as designed.
- Update protocol: working as designed.
- Update behavior at session end: well-calibrated.

Reply with proposed edits to apply (numbers), or "discuss <number>" to talk through one.
```

## Algorithm

1. Verify coach has enough data (>30 sessions, >90 days old)
2. Read CLAUDE.md, parse into sections
3. Read 90-day sessions and inbox history
4. For each section of CLAUDE.md, ask: does the data validate this rule?
5. For patterns in the data, ask: is there a CLAUDE.md section that addresses this?
6. Compose findings; for each, propose a specific edit (with diff-style before/after)
7. Show user; wait for input
8. Apply approved edits to CLAUDE.md
9. Regenerate snapshot via `vault-push-snapshot`
10. Update `~/.cache/vault-coach-meta-review-history.json`

## Sample edit format

When proposing a CLAUDE.md edit, show concrete before/after:

```diff
## Voice
- Direct, technically precise, encouraging without coddling
+ Warmer than direct — validate effort before correction. Technically precise
+ when needed; conversational otherwise. Match the user's energy.
```

Don't ask the user to redraft; do the redraft and ask for approval.

## Don't

- Don't run before 30 sessions or 90 days (not enough data)
- Don't propose >5 edits per review (overwhelming)
- Don't rewrite the entire CLAUDE.md (incremental edits only)
- Don't be self-deprecating ("I've been failing you...") — just propose changes
- Don't propose changes that conflict with `_shared/principles.md` without flagging
- Don't apply edits without explicit user approval

## Why this matters

A coach that can't adjust its own design is a static template, no different from `examples/` in the public repo. Quarterly meta-review is what keeps your coach genuinely *yours* — drifting toward what works for you specifically, not what worked at template-design time.

This is also the slowest improvement loop. Per-conversation extraction is fast (every session). Coach-evolve is medium (every 10 sessions). Coach-meta-review is slow (quarterly). Three timescales catch different patterns.
