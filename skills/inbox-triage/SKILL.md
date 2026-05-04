---
name: inbox-triage
description: Process vault root Inbox.md entries and route each one to its proper home — People, Places, Restaurants, Events, coach folders, or Ideas. Triggered on user request "triage inbox", "process inbox", "clean up inbox", or when Inbox.md exceeds ~30 lines.
---

# Skill: inbox-triage

Inbox.md is a capture surface, not a home. This skill takes everything in Inbox.md and proposes where each item belongs in the vault — then applies after user confirmation.

Distinct from `idea-distill`: idea-distill focuses on developing *ideas* (Ideas/ folder, pattern detection). Inbox-triage routes *all* inbox entries — people notes, restaurant visits, event captures, coach-relevant observations, actionable items, ideas — to the right file in the vault.

## When to invoke

- User says: "triage inbox", "process inbox", "route inbox", "clear my inbox"
- Inbox.md exceeds ~30 lines (signal: too much to reason about)
- During weekly review (inbox should be empty or near-empty by Sunday)
- After a week with many spontaneous captures (travel, events, social week)

## What counts as "Inbox.md"

The vault root `Inbox.md` — typically at `$VAULT/Inbox.md`. This is the default capture point for the `brain` alias. Not to be confused with coach-level inbox files (those are Drive-sourced; handled by `vault-pull-inbox`).

## Routing decisions

For each entry in Inbox.md, determine the right destination:

| Entry type | Destination |
|---|---|
| Note about a person | `People/<firstname-lastname>.md` (create if missing) |
| Restaurant visit, recommendation | `Restaurants/<city>/<slug>.md` (create if missing) |
| Place note (gym, venue, neighborhood) | `Places/<slug>.md` (create if missing) |
| Event recap, meeting notes | `Events/<YYYY-MM-DD-slug>.md` (create if missing) |
| Coach-relevant observation | Coach inbox write — propose surfacing to `Coaches/<coach>/profile.md` or via next session |
| Idea, hypothesis, exploration | → leave for `idea-distill`, or move to `Ideas/<slug>.md` if clearly standalone |
| Actionable to-do | → `Projects/<project>.md` or remain in Inbox.md with a tag |
| Reading, article, link | → `Reading/<slug>.md` |
| Ambiguous / can't classify | → propose to user with two options |

## Algorithm

1. Read `Inbox.md`
2. Parse entries: split on blank lines between items, or look for `##` headings, or date-prefix patterns (`YYYY-MM-DD — `)
3. For each entry:
   - Determine entry type (use the routing table above)
   - If routing target file exists: propose appending to its Log section
   - If routing target file does not exist: propose creating from template
4. Group into batches by destination type (all People entries together, etc.)
5. Compose a triage report

## Triage report format

```
## Inbox Triage (2026-05-04) — 8 entries

### Route to People/ (2)
1. "Alex mentioned he's moving to NYC in June" → append to [[People/alex-smith]] log
2. "Need to thank Jordan for the intro" → create [[People/jordan-lee]] with note + follow-up item

### Route to Restaurants/ (1)
3. "Dinner at Nopa Tuesday, goat cheese flatbread was exceptional" → append to [[Restaurants/sf/nopa]] visits

### Route to Events/ (1)
4. "Strategy offsite wrap-up — decided to pause the reorg" → create [[Events/2026-04-28-strategy-offsite]]

### Route to Coaches/ (2)
5. "Sleep been bad all week, definitely affecting pole class" → surface to fitness coach or pole coach next session
6. "Finally nailed a clean shoulder mount entry on Tuesday" → add to pole sessions.md if not already logged

### Route to Ideas/ (1)
7. "What if we built a public LifeOS dashboard?" → create [[Ideas/lifeos-dashboard]]

### Leave in Inbox.md (1)
8. "Book dentist appointment" — actionable, no vault home. Move to a project or handle directly?

---

Reply "all" to apply everything, or pick item numbers to skip.
After applying, I'll clear routed entries from Inbox.md.
```

## Applying

After user confirms:
1. For each confirmed route: write to destination file (append to log, or create from template)
2. For new files created from template: pre-fill what's known from the inbox entry; leave placeholders for unknowns
3. Remove routed entries from Inbox.md (leave only unrouted / deferred / user-rejected items)
4. Report: "Routed N entries, created X new files. Inbox.md now has Y remaining items."

## Wikilink convention

When creating or updating a file, add the relevant cross-link back. If you create `People/alex-smith.md` from an inbox entry about a dinner, and that dinner has a restaurant note, link them:

In `People/alex-smith.md` — under "Associated notes": `[[Restaurants/sf/nopa]]`
In `Restaurants/sf/nopa.md` — under "Associated notes": `[[People/alex-smith]]`

Don't exhaustively link everything; only link when the connection is load-bearing (you'll want to navigate between them).

## Don't

- Don't route without showing the triage report first — always confirm before writing
- Don't delete Inbox.md entries you're not routing (user may want to process them differently)
- Don't create a People/Places/Restaurants file for a one-off mention that doesn't warrant a permanent file (e.g., "mentioned a barista who was rude" doesn't need `People/rude-barista.md`)
- Don't invent wikilinks to files that don't exist yet — only link to files you're creating in this same triage run or that already exist
- Don't triage coach-level inbox files — those are handled by `vault-pull-inbox`
- Don't run if Inbox.md doesn't exist or is empty — tell the user: "Inbox.md is empty. Nothing to triage."

## Why this matters

Every hour a note sits unrouted in Inbox.md is an hour it can't cross-link, can't be found by search, and can't inform a coach. A full inbox is friction. An empty inbox is a cleared mind. This skill is the mechanism that keeps the vault a living system rather than a notes graveyard.
