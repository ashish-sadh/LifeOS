# Cooking Coach Example

Template for a cooking coach. Use this as the starting point when spawning a `GetBetterAtCooking` coach.

## What's distinctive about this domain

- **Recipe-based memory**: each recipe you try gets a file (`recipes/<dish>.md`) with attempts, modifications, ratings, learnings.
- **Technique progression**: knife skills, sourdough, stocks, sauces, fermenting — each grows over time as a separate skill.
- **Pantry awareness**: what you keep stocked, what you need to restock, what's in season.
- **Dietary context**: allergies, preferences, who you're cooking for.
- **Equipment matters**: gas vs electric, cookware, knives — affects what's realistic.

## Distinctive folder structure

```
Coaches/GetBetterAtCooking/
├── CLAUDE.md
├── profile.md
├── recipes/                     One file per dish you've tried
│   ├── kale-pasta.md
│   ├── thai-curry.md
│   └── ...
├── techniques/                  Skill-building references
│   ├── knife-skills.md
│   ├── sourdough.md
│   └── ...
├── ingredients/                 Pantry knowledge
│   ├── pantry.md               (what you keep stocked)
│   ├── seasonal.md             (in-season this month)
│   └── substitutions.md        (X for Y when you've tested)
├── learnings.md                 Cross-cutting insights
├── sessions.md                  What you cooked, how it went
├── patterns.md                  Coach's accumulated observations about you
└── context-snapshot.md
```

## Things to seed when spawning

The `spawn-coach` skill will ask:
1. Your kitchen (gas/electric, key tools, cookware)
2. Your knife situation
3. What you typically have stocked
4. Dietary constraints (medical, ethical, preference)
5. What you cook most weeks now
6. What you've never cooked but want to nail
7. Skills you want to develop (knife, sourdough, sauces, plating, fermenting)
8. When/how you want to chat with the coach (pre-cook brief, post-cook log, mid-cook help, weekly planning)

## Recipe file template

```markdown
# Kale Pasta

**Source**: NYT Cooking, Alison Roman (link)
**Times tried**: 4
**Last cooked**: 2026-08-12
**Rating**: 4/5 (your version)

## Your version (current best)

Ingredients:
- 1 lb pasta (rigatoni preferred)
- 2 bunches Tuscan kale
- ...

Method:
1. ...

## Your modifications
- 30% less salt than original (your salt brand is salty)
- Added pinch of red pepper flakes
- Skip Parmesan, use pecorino

## What went wrong (and fixes)
- 2026-08-12: kale wilted too fast — next time, sauté garlic first then add kale 30 sec before pasta
- 2026-07-04: too oily — reduce olive oil to 3 tbsp from 5

## Variations to try
- Add anchovy paste for umami
- Sub kale with cavolo nero in winter
```

## Technique file template

```markdown
# Knife Skills

**Started focusing on**: 2026-09-01
**Current level**: improving rock chop; struggling with chiffonade

## Current focus
- Rock chop on onions (consistent)
- Chiffonade on basil (rolling tightly enough)

## Progressions made
- 2026-09-15: rock chop now feels natural
- 2026-09-22: knife sharpening — taught to use whetstone

## Stuck
- Tip-pivot for fine chopping — keeps swinging too wide

## References
- [[recipes/kale-pasta]] — first recipe where chiffonade matters
```

## Tips

1. **Capture failures**, not just successes. The "what went wrong" section in each recipe is gold.
2. **Track substitutions** that worked — your `substitutions.md` becomes a personal cookbook reference over time.
3. **Photograph your wins** (and store paths in recipe files) — visual memory helps.
4. **Note the why** — "added anchovy paste because the dish was missing umami" is more useful than "added anchovy paste."
