---
name: coach-research
description: Web-search for new domain knowledge relevant to the current coach's user, filtered by level, current focus, and open gaps. Propose findings as vocabulary additions, session topics, or program adjustments. Triggered on user request "research for me", "what's new in [domain]?", "learn something", or automatically by the weekly Sunday research scheduled job.
---

# Skill: coach-research

Coaches that don't update their domain knowledge get stale. This skill runs targeted web searches for new techniques, findings, or best practices in the coach's domain, filters them for the specific user's context, and proposes concrete additions.

## When to invoke

- User says: "research for me", "what's new in [domain]?", "look something up", "learn something new for this coach"
- Scheduled: weekly Sunday 10am via `.claude/scheduled/weekly-sun-10am-research.sh`
- After a user mentions something unfamiliar: "I heard about [X technique] — is that relevant to me?"
- When coach's vocabulary hasn't been updated in >30 days

## Pre-flight checks

Before searching, read:
1. `Coaches/<coach>/profile.md` — user level, current focus, injuries, known failure modes
2. `Coaches/<coach>/vocabulary.md` — what's already documented (avoid re-finding known things)
3. `Coaches/<coach>/program.md` — current block and weekly focus
4. Last 3 `sessions.md` entries — what's been discussed recently

These reads take 30–60 seconds but make the searches far more targeted. Don't skip them.

## Search query strategy

Generate 3–5 targeted queries based on what you learned from the pre-flight reads. Good queries are:

- **Level-specific**: don't search "how to do a shoulder mount" for an advanced user — search "shoulder mount technique common errors intermediate aerial"
- **Focus-specific**: if the user is mid-shoulder-mount progression, prioritize that
- **Gap-aware**: check `profile.md`'s "Open gaps" or "Ongoing curiosity" sections — search for those topics
- **Injury-aware**: if the user has an active injury, filter out content that would aggravate it; optionally search for injury-specific modifications

Bad query: `"pole dance tips"`
Good query: `"aerial shoulder mount external rotation cue intermediate"`

Bad query: `"cooking techniques"`
Good query: `"knife maintenance whetstone angle Japanese knife home cook"`

## Source quality filter

Prefer sources in this order:
1. Published books, peer-reviewed research (via Google Scholar links, or cited in results)
2. Instructors with verifiable credentials (published coaches, competitive athletes, culinary school instructors)
3. High-quality instructional blogs and YouTube channels with domain authority
4. Reddit/forums: acceptable for technique discussions; flag as community consensus not expert opinion

Reject:
- SEO-farmed content ("Top 10 tips for..." without substance)
- Clickbait titles with thin content
- Sources that contradict established practice without evidence

## Research report format

```
# Coach Research Report — <Domain> Coach (<YYYY-MM-DD>)

## Summary
<One paragraph: what's worth the user's attention this week, and why now.>

## Findings

### 1. [Finding title]
**Source**: <name + URL>
**Why this is for you**: <specific connection to user's level, current focus, or open gap>
**Proposed action**: <add to vocabulary / try in next session / discuss with instructor / update program>
**Confidence**: high / medium / low

### 2. [Finding title]
...

## Considered but skipped
- [X]: <reason — too beginner / already in vocabulary / not credible / aggravates injury>
- [Y]: <reason>

## Related vault context
- Already in vocabulary: [[Coaches/<coach>/vocabulary.md#entry]]
- Relevant sessions: <brief note on where this topic appeared before>

---
Reply with finding numbers to accept (e.g., "1, 3"), "all", or "skip".
After accepting: I'll add findings to vocabulary.md (new entries) or surface as session topic.
```

## Applying findings

After user confirms which findings to apply:

| Finding type | Where it goes |
|---|---|
| New term or concept | `vocabulary.md` (new entry with source citation) |
| Technique refinement | `vocabulary.md` (update existing entry with note) |
| New exercise or drill | `program.md` (add to current week's supplemental work) |
| Injury modification | `profile.md` (append under active constraints) |
| Interesting but not actionable | Note in `sessions.md` as "research surfaced — revisit later" |

Always cite the source in the vocabulary entry: `Source: <name>, <URL>`.

## Frequency and focus rotation

Running the same queries every week produces diminishing returns. Rotate focus:

- **Week 1**: current technique focus (what's in `program.md` this block)
- **Week 2**: a known failure mode or asymmetry from `profile.md`
- **Week 3**: an open gap from "Ongoing curiosity" in `profile.md`
- **Week 4**: emerging trends or recent publications in the domain

Track last search topics in `~/.cache/vault-coach-research-history.json`:
```json
{
  "version": 1,
  "coaches": {
    "pole": {
      "last_run": "2026-05-04T10:00:00Z",
      "last_focus": "shoulder mount rotation",
      "rotation_week": 1
    }
  }
}
```

## Domain-specific search guidance

**Pole / Aerial**: Look for content from competitive aerial athletes, movement science research (shoulder mechanics, grip strength periodization), and established studios (Aerial Physique, Pole Sport Organization). Avoid Instagram-only personalities without verifiable credentials.

**Fitness / Strength**: Prioritize peer-reviewed exercise science (NSCA journals, Stronger by Science), established coaches (Greg Nuckols, Mike Israetel). Search for: periodization research, technique refinements for specific lifts the user is working on.

**Cooking**: Prioritize culinary school resources, food science (Serious Eats, Harold McGee), and chef-authored content. Search for: specific techniques the user is developing, ingredient science, flavor pairing research.

**Thinking**: Look for decision theory research, cognitive psychology findings, applied philosophy. Filter for: practical frameworks, not just theory. Watch for replication-crisis work in psychology — flag confidence accordingly.

**Speaking**: Prioritize speech coaches with verifiable track records, rhetoric research, and feedback from actual talks (not just "tips" content). Focus on the user's specific failure modes.

**Writing**: Prioritize craft books and established editor/author voices (Paris Review interviews, Strunk & White lineage, specific authors the user admires). Avoid generic "how to write" listicles.

## Don't

- Don't search without reading the pre-flight files — searches without context produce generic results
- Don't propose more than 5 findings per run (overwhelming; better to do fewer high-quality finds)
- Don't add findings without user confirmation
- Don't propose content that contradicts things already in vocabulary without flagging the conflict: "This source disagrees with your vocabulary entry on X — worth discussing?"
- Don't run if the user has said they want to avoid new info (e.g., during a competition prep block where they're executing, not learning)
- Don't cite Reddit as authoritative — include forum findings as "community discussion on X" not "experts recommend X"

## Why this matters

A human coach reads journals, attends workshops, watches other coaches' students, and keeps up with the domain. An AI coach reads its own files and whatever the user brings. Without an active research mechanism, the coach's domain knowledge is frozen at training time. Coach-research is the mechanism that keeps domain knowledge current — not as good as a human expert, but meaningfully better than nothing.
