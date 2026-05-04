---
name: New skill
about: Propose or submit a new Agent Skill (a reusable behavior that coaches can invoke)
title: "[SKILL] <skill-name>"
labels: new-skill
assignees: ''
---

## Skill name

<!-- kebab-case, e.g., "weekly-research", "context-compare", "coach-handoff" -->

## What gap does this fill?

<!-- What can't users do today without this skill?
     Which part of the lifecycle is missing: onboarding, session, post-session, maintenance, cross-coach, research? -->

## Trigger phrases

<!-- When should this skill auto-invoke, and what does a user say to trigger it manually?
     Examples: "research my domain", "compare my two coaches", "what am I avoiding?" -->

## Algorithm (sketch)

<!-- What are the steps the skill takes?
     Be specific about what files it reads and writes.
     If it requires user confirmation before modifying files, say so explicitly. -->

1. 
2. 
3. 

## Output format

<!-- What does the user see when the skill runs?
     A report? A prompt for confirmation? Silent file writes? Show a sample. -->

## Edge cases considered

<!-- What happens when:
     - The relevant files don't exist yet?
     - The skill is called too soon after the last run?
     - The user rejects the output?
     Other edge cases specific to this skill. -->

## Files it reads / writes

| File | Read / Write | Notes |
|---|---|---|
| `Coaches/<coach>/...` | read | |
| | write | |

## Checklist before PR

- [ ] `skills/<name>/SKILL.md` with valid frontmatter (`name`, `description`)
- [ ] Section: When to invoke (trigger phrases + auto-trigger conditions)
- [ ] Section: Algorithm (numbered steps)
- [ ] Section: Output format (with example)
- [ ] Section: Don't (anti-patterns, skip conditions)
- [ ] No hardcoded paths or personal data
