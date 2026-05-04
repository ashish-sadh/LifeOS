---
name: weekly-review
description: Synthesize the past 7 days across all coaches and daily notes into a weekly review. Triggers on "weekly review", "what happened this week", or when user runs the brain alias on Sunday.
---

# Skill: weekly-review

Once a week, synthesize everything that happened across coaches and daily notes into a coherent picture.

## When to invoke

- User asks: "weekly review", "what happened this week", "Sunday review"
- User runs `brain` alias and asks for a summary
- Cadence: ideally Sunday morning (but invoke whenever asked)

## What to read

1. All `Daily/YYYY-MM-DD.md` files from the last 7 days
2. `Coaches/<each-coach>/sessions.md` — last 7 days of entries
3. `Inbox.md` — anything appended in the last 7 days
4. `Ideas/` — any new files created in the last 7 days

## What to produce

A markdown synthesis written to `Daily/YYYY-MM-DD-weekly-review.md`. Sections:

### Per coach (only coaches with activity in the past week)
- Sessions count
- Wins / progress
- Stuck points or red flags
- Body / energy patterns (for physical coaches)
- Action for next week

### Themes from Daily notes and Inbox
- What did the user keep coming back to?
- Any 3+ mentions of the same topic = surface it
- Anything that crosses coach boundaries

### Cross-coach observations
- Are there links between coaches the user might be missing?
- E.g., "Pole shoulder mount stuck → Fitness pull strength weak → connect these"

### Action items for next week (3-5 max)
Concrete, scoped, specific. No more than 5.

### Open questions / next interview gaps
What gaps in `_shared/profile.md` or coach profiles should we naturally fill in next week?

## Tone

Direct, specific, no fluff. The user reads this in 3-5 minutes; make every paragraph earn its space.

## Don't

- Don't write a generic "here's what you did" report — anyone could write that. Earn your role by surfacing patterns the user might miss.
- Don't moralize ("you skipped 2 days, you should be more consistent"). Just observe.
- Don't manufacture themes — if the week was quiet, say so. Three good sessions of pole = a real week, not a weak week.
