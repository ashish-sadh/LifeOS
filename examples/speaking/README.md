# Speaking Coach Example

Template for a public speaking and communication coach. Use this as the starting point when spawning a `GetBetterAtSpeaking` coach.

## What's distinctive about this domain

- **Talk-level tracking**: unlike fitness (sessions) or thinking (decisions), speaking accumulates value per individual talk. Each talk is a file with prep notes AND post-event debrief — the pair is what lets the coach spot patterns.
- **Themes as a tracking primitive**: delivery patterns (good and bad) compound across talks. The `themes/` folder captures recurring rhetorical elements — things to lean into and tics to correct.
- **Structure over content**: the coach's job isn't to write the talk. It's to help the user find the right structure, the right message, the right opening. Content is theirs.
- **Audience context matters more here than in most domains**: a coaching response for an exec talk vs. a meetup talk vs. a team standup is completely different. Always establish audience before advising.
- **Anxiety is a first-class variable**: for many people, anxiety shapes speaking more than technique. The coach tracks anxiety triggers and develops specific protocols, not generic "breathe deeply" advice.

## Distinctive folder structure

```
Coaches/GetBetterAtSpeaking/
├── CLAUDE.md
├── profile.md
├── talks/                       One file per prepared talk
│   ├── 2026-09-15-team-strategy-talk.md
│   ├── 2026-10-08-conference-keynote.md
│   └── ...
├── themes/                      Recurring delivery patterns (good and bad)
│   ├── rushing-the-close.md
│   ├── opening-with-a-question.md
│   └── ...
├── feedback/                    Structured post-event feedback (optional)
│   └── 2026-09-15-engineering-allhands.md
├── sessions.md                  Coach conversations
└── context-snapshot.md
```

## What to seed when spawning

The `spawn-coach` skill will ask:

1. What contexts do you speak in most? (Internal / external / customer / exec / technical / general audience)
2. What's your overall level? (Beginner / occasional speaker / regular presenter / experienced)
3. What brings you to a speaking coach now? (Specific upcoming talk / general improvement / anxiety / clarity of message)
4. Delivery strengths you know you have?
5. Delivery patterns you know are problems?
6. Anxiety level (1-10) and what triggers it?
7. Recurring feedback you've heard more than once?
8. What's the talk you want to give but haven't had the nerve to propose?

## Talk file format

Each talk lives in `talks/` and has two phases:

**Phase 1 — before the talk** (prep):
- The one thing: one sentence on what you want the audience to think/feel/do
- Audience profile
- Structure: segment-by-segment with time targets
- Opening line (rehearsed cold)
- Rehearsal notes (run by run)
- Delivery notes to self

**Phase 2 — after the talk** (debrief):
- What worked (specific moments, not "it went well")
- What to change next time (specific, not "be less nervous")
- Feedback received (verbatim where possible)
- Themes surfaced (cross-linked to themes/)

The two-phase file means the coach can read both the intention and the reality for each talk, and spot the recurring delta.

## Theme file format

A theme is a recurring rhetorical element — positive or negative. Examples:
- Positive: "strong opening with a concrete observation", "uses stories to anchor abstractions"
- Negative: "rushing the close", "filler words under pressure", "loses eye contact when thinking"

Each theme file tracks:
- Definition and why it matters
- Specific talks where it appeared
- Root cause hypothesis
- Fix protocol (for negatives) or "lean in" notes (for positives)
- Progress notes over time

Themes are more durable than individual talks — they're the compound learning across the whole library.

## Tips

1. **Log the debrief same day**. Memory of what worked and what didn't degrades within 24 hours.
2. **Specific beats vague**. "The opening landed" is not useful. "The opening line caused the room to go quiet and I had their attention immediately" is.
3. **One talk, two files is too much overhead**. Keep prep and debrief in the same file. The coach reads both.
4. **Themes emerge after 3+ observations**. Don't create a theme file after one talk — wait until you see a pattern. Then name it precisely.
5. **The coach reads themes before responding to prep questions**. If "rushing the close" is in your themes, the coach will proactively address it without you having to ask.
