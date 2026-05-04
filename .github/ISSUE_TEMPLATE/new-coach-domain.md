---
name: New coach domain
about: Propose or submit a new coach domain template (e.g., language learning, woodworking, parenting)
title: "[COACH] <domain name>"
labels: new-coach
assignees: ''
---

## Domain name

<!-- What is the coaching domain? Examples: language-learning, woodworking, parenting, meditation, finance -->

## Why this domain works as a coach

<!-- What makes this domain benefit from persistent personalized memory?
     What would a good session with this coach look like after 6 months of use?
     What is the distinctive file structure (does it need vocabulary.md, recipes/, decisions/, something else)? -->

## Distinctive structure

<!-- List the files/folders that would live in Coaches/GetBetterAt<Name>/
     beyond the standard set (CLAUDE.md, profile.md, sessions.md, context-snapshot.md).
     Explain what each adds. -->

```
Coaches/GetBetterAt<Name>/
├── CLAUDE.md
├── profile.md
├── sessions.md
├── context-snapshot.md
└── <domain-specific folder or file>
```

## Sample session

<!-- What would a real coach conversation look like?
     Give a 3-5 message exchange showing the coach working with actual domain knowledge.
     Sanitize any personal data. -->

## Onboarding interview sketch

<!-- What 3-5 questions would you ask in Round 1 of the spawning interview?
     These should surface the user's level, history, and most important context for this domain. -->

## Checklist before PR

- [ ] `examples/<domain>/CLAUDE.md` — coach persona and reading protocol
- [ ] `examples/<domain>/profile.md` — domain-specific user state (with placeholders)
- [ ] `examples/<domain>/sessions.md` — session log format with 1-2 sample entries
- [ ] `examples/<domain>/context-snapshot.md` — phone-ready digest template
- [ ] `examples/<domain>/README.md` — what's distinctive about this domain
- [ ] Domain-specific files/folders (with at least one realistic sample file)
- [ ] No real personal data (Drive IDs, real names, real session details)
