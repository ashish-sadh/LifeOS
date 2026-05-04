# Thinking Coach Example

Template for a thinking / clarity-of-thought coach. Use this as the starting point when spawning a `GetBetterAtThinking` coach.

## What's distinctive about this domain

- **Decision tracking**: not just thinking *about* things, but capturing decisions and predictions to calibrate over time.
- **Mental models library**: build up your own collection of ones you actually use.
- **Daily journal**: short reflections that surface patterns over weeks.
- **Pattern recognition**: themes that appear across decisions, journal entries, conversations.
- **Reading integration**: books you read, ideas you absorb, mental models added to library.

## Distinctive folder structure

```
Coaches/GetBetterAtThinking/
├── CLAUDE.md
├── profile.md
├── decisions/                   Decision journal entries
│   ├── 2026-09-15-job-offer.md
│   └── 2026-09-22-investment-x.md
├── models/                      Your collected mental models
│   ├── inversion.md
│   ├── second-order-thinking.md
│   ├── opportunity-cost.md
│   └── ...
├── journal/                     Daily / weekly reflections
│   ├── 2026-09-15.md
│   └── ...
├── predictions/                 Calibration tracking
│   └── 2026-q3-predictions.md
├── patterns.md                  Recurring themes across decisions/journal
├── reading-influences.md        Which sources have shifted thinking
├── sessions.md                  Conversations with coach
└── context-snapshot.md
```

## What to seed when spawning

The `spawn-coach` skill will ask:
1. What does "think more clearly" mean to you specifically?
   - Better decisions
   - Less reactivity
   - Faster synthesis
   - Sharper writing/speaking
   - Calibrated forecasts
   - Other
2. Recent failure mode that pushed you to try this?
3. Mental models you already use and like?
4. Mental models you've heard of but don't really use?
5. Decision journaling history (have you tried? does it stick?)
6. Reading/listening habits relevant to thinking
7. How often do you want to engage? Daily journaling? Weekly review? When stuck on a decision?

## Decision file template

```markdown
# 2026-09-15 — Accept job offer at X?

**Status**: deciding (decision deadline: 2026-09-22)
**Tags**: #career #high-stakes

## Context
- Current situation
- The offer

## Considerations
- For
- Against
- Unknowns

## Mental models I'm using
- [[models/opportunity-cost]] — what am I trading?
- [[models/regret-minimization]] — which choice will I regret more?

## My prediction (with confidence)
If I take the offer, I predict: <specific, falsifiable claim>
Confidence: <0-100%>

## Decision
<after deciding>

## Outcome (revisit in 6 months)
<2027-03-15: filled in later>
```

## Mental model file template

```markdown
# Inversion

**Where I learned it**: Charlie Munger via [[reading-influences/poor-charlies-almanack]]
**Times I've used it**: 14
**Effectiveness**: high — usually surfaces non-obvious failure modes

## What it is
Instead of asking "how do I succeed?", ask "how do I fail?" Then avoid those.

## When it works for me
- Project planning
- Decision unpacking when stuck
- Pre-mortems before launch

## When it doesn't help
- Creative ideation (limits options)
- Time-pressured calls

## Examples I've applied it to
- [[decisions/2026-09-15-job-offer]] — what would make accepting this regrettable?
```

## Tips

1. **Prediction tracking matters most**. Most "thinking journals" become diaries. Adding predictions with confidence makes you actually calibrated.
2. **Mental models are useful only after 5+ uses**. Don't pre-collect; let them earn their slot.
3. **Daily journal can be 2 sentences**. Don't make it a chore. Just: "what surprised me today?" + "what am I still chewing on?"
4. **Coach reviews patterns weekly** — if you've journaled "tired" 5 days in a row, the coach mentions it. The compound value is the pattern recognition you'd miss alone.
