---
name: cross-domain-link
description: Scan vault files across People, Places, Restaurants, Events, and coach folders to find missing wikilinks between related files, and propose adding them. Triggered on user request "find links", "cross-link vault", "what connects to X?", or periodically after inbox-triage runs.
---

# Skill: cross-domain-link

The value of the vault compounds when notes reference each other. A person file that links to the restaurants you've been to together, the events they attended, the places they frequent — that's richer than three disconnected files. This skill scans for obvious missing links and proposes adding them.

## When to invoke

- User says: "find links", "cross-link the vault", "what connects to X?", "link things up"
- After `inbox-triage` runs and created several new files
- When user adds a new person/place/restaurant and wants to backfill links
- Periodically (e.g., monthly via `vault-maintain`) to catch accumulation

## What it scans

1. **Name mentions** — scan all files in People/, Places/, Restaurants/, Events/, and coach folders for plain-text mentions of names that correspond to vault files. If `People/alex-smith.md` exists and `Restaurants/sf/nopa.md` mentions "Alex" or "Alex Smith", both should link to each other.

2. **Shared events** — if `Events/2026-05-04-dinner.md` mentions a person and a restaurant, all three should cross-link.

3. **Coach folder mentions** — if `People/alex-smith.md` mentions "pole" or "climbing gym", check if a relevant coach folder exists and if the person should be linked there (e.g., a training partner, an instructor).

4. **Orphan files** — files in People/, Places/, Restaurants/, Events/ that have no incoming wikilinks from any other vault file. These aren't necessarily wrong, but they're worth surfacing.

## Algorithm

1. Build a name-to-filepath index:
   - People/ → each file's title = person name, also note the first-name shorthand
   - Places/ → each file's title
   - Restaurants/ → each file's title (and city subfolder)
   - Events/ → each file's title

2. For each file in the scanned directories:
   - Search content for mentions of indexed names (case-insensitive; partial match on first name if unambiguous)
   - Check if the mention is already a `[[wikilink]]`
   - If not: record as a missing link candidate

3. Filter candidates:
   - Skip very short mentions that could be coincidental (e.g., "Alex" is a common name — only flag if context clearly refers to the person)
   - Skip self-references
   - Skip mentions in the Associated notes section already

4. Compose a link proposal report

## Link proposal report format

```
## Cross-domain Link Report (2026-05-04) — 6 proposals

### People ↔ Restaurants (2)
1. [[People/alex-smith]] — mentions "Nopa" in log entry 2026-04-20. Add [[Restaurants/sf/nopa]] to associated notes?
2. [[Restaurants/sf/shizen]] — log entry mentions "came with Jordan for Jordan's birthday". Add [[People/jordan-lee]]?

### People ↔ Events (2)
3. [[People/alex-smith]] — "strategy offsite" in log. Matching [[Events/2026-04-28-strategy-offsite]] exists. Cross-link?
4. [[Events/2026-04-28-strategy-offsite]] — mentions "Alex" in attendees. Add [[People/alex-smith]] to "who was there"?

### Orphan files (1)
5. [[Places/home-office]] — no incoming links from any other vault file. Still useful? Or add a link from a coach folder?

### Coach ↔ People (1)
6. [[People/sarah-instructor]] — log says "pole instructor at SF Pole & Dance". Add context linking to [[Coaches/GetBetterAtPole]]?

---
Reply with numbers to apply (e.g., "1, 2, 4"), "all", or "skip".
```

## Applying

For each confirmed link:
- Add to the file's "Associated notes" section (if it exists) or create that section
- Write the wikilink in both directions: if A links to B, also add B → A (unless the reverse is already there)
- Never overwrite existing content — append to the section

## Scope options

By default: scan the whole vault. The user can scope it:
- `"cross-link People/alex-smith"` — only find links for that specific file
- `"cross-link People/"` — only scan the People folder
- `"cross-link Events/ to Restaurants/"` — only look for that specific pairing

Scoped runs are faster and less noisy when the user knows what they want.

## Don't

- Don't add wikilinks in running prose — only add them in "Associated notes" sections. Prose links clutter the reading experience.
- Don't flag ambiguous first-name mentions as missing links unless context clearly identifies the person (e.g., "talked to Alex at the offsite" where the event file references Alex Smith)
- Don't create files — only add links to existing files
- Don't link across coach folder content (e.g., don't scan `Coaches/GetBetterAtPole/sessions.md` for all person mentions — that's too noisy)
- Don't apply without confirmation — always show the report first
- Don't run on vault root files (Inbox.md, Daily/, Ideas/) — those are capture surfaces, not reference nodes

## Why this matters

Isolated notes don't surface intelligence. When your vault knows that Alex Smith, Shizen restaurant, and the May 2026 birthday dinner are all connected, a question like "who have I had meaningful meals with this year?" becomes answerable by reading a person file instead of searching across scattered notes. Cross-domain linking is what turns a note collection into a knowledge graph.
