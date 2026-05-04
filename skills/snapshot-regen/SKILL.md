---
name: snapshot-regen
description: Regenerate a coach's context-snapshot.md file based on current state of profile, program, vocabulary, and recent sessions. Invoke after any substantive update via obsidian-sync skill, or when user asks for a "fresh snapshot" or "update phone snapshot".
---

# Skill: snapshot-regen

The `context-snapshot.md` file is the **digest** that phone-Claude reads first to get current context. It must be kept fresh so that mobile sessions don't operate on stale data.

## When to invoke

- After substantive updates to `profile.md`, `program.md`, `vocabulary.md`, or after a new `sessions.md` entry
- When user explicitly asks: "update my snapshot", "refresh phone context", "regenerate snapshot"
- At the end of any conversation that ran the `obsidian-sync` skill

## What to do

1. Read all four sources for the coach:
   - `Coaches/<Coach>/profile.md`
   - `Coaches/<Coach>/program.md`
   - `Coaches/<Coach>/vocabulary.md` (just status, not full definitions)
   - `Coaches/<Coach>/sessions.md` (last 3-5 entries)
2. Also read `_shared/profile.md` for global facts.
3. Compose a compact digest (~500-1000 words max) covering:
   - **Who**: 1-2 sentence user summary (age, body, key context)
   - **Studio / setup**: where they train
   - **Level**: current self-assessed level
   - **Repertoire**: clean moves, drifting moves, current edge
   - **Active block**: name, week, focus areas
   - **Recent context**: last 2-3 session summaries (compressed)
   - **Open gaps**: things still to discover
   - **Coaching priorities**: what to emphasize
   - **How to greet**: what a "welcome back" should reference

4. Write to `Coaches/<Coach>/context-snapshot.md`, **replacing the previous content** (this file is regenerated, not appended).

5. Update the `last_regenerated` field in frontmatter to today's date.

## Why this matters

This is the file phone-Claude (via Drive connector) reads to bootstrap context. If it's stale, mobile sessions will give stale advice. A coaching system without a fresh snapshot = a coaching system that forgets what happened on Mac.

## Don't

- Don't include full file contents (it's a digest, not a copy)
- Don't include session-by-session details (only patterns and recent highlights)
- Don't omit the open gaps section — surfaces what to ask next
