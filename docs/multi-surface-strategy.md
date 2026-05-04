# Multi-surface strategy — when to use which AI surface

LifeOS is designed to run on any AI surface that can read your vault. The surfaces have different strengths. This document shows real usage patterns so you can pick the right tool for the moment.

---

## The surfaces, briefly

| Surface | Best for | Vault access |
|---|---|---|
| **Mac CLI** (`claude --dangerously-skip-permissions`) | Deep work, coaching sessions, vault updates, automation | Full filesystem + skills |
| **Claude.ai phone** | On-the-go sessions, quick captures, voice coaching | Read + create (Drive connector) |
| **Gemini** | Quick lookups, Gmail/Calendar context, faster responses | Full CRUD (native @Drive) |
| **ChatGPT** | GPT-4o-specific tasks, fallback | Read + create (Drive connector) |
| **Claude Desktop** + mcp-obsidian | Non-terminal Mac/Windows users, occasional sessions | Read + write (MCP) |
| **Voice assistants** | Hands-free capture during activity | Limited (see `_ai/voice-assistants.md`) |

Full setup for each: see `_ai/<surface>.md`.

---

## By situation

### "I have 45 minutes for a deep coaching session"

**Use Mac CLI.**

- Coach's CLAUDE.md auto-loads from the folder
- Skills (vault-pull-inbox, obsidian-sync, vault-push-snapshot) run automatically
- Session history integrates into canonical files as you go
- Snapshots push to Drive so phone has fresh context for next time

```bash
pole   # or: cook, think, fit, write, etc.
```

### "I just finished a workout and want to log it quickly"

**Use Claude.ai phone (or Gemini on Android).**

You're still warm, possibly sweaty. You have 3 minutes.

Claude.ai phone reads the latest snapshot → already knows your training context → you say:
> *"35-minute lower body. Deadlifts 3x5 at 185, felt easy. Hip hinge starting to click. Left hip still grabs at top."*

Coach responds with 2-3 observations and creates an inbox file. Mac integrates it next session.

Gemini works identically here and is faster on Android if you have it set up.

### "I'm in a meeting and need to remember something to tell my thinking coach"

**Use Inbox.md directly, or Claude.ai voice.**

Fastest option: open Inbox.md in any editor (Drive Desktop syncs it) and type the note. No AI needed. The `inbox-triage` skill routes it later.

If you're on phone: ask Claude.ai "remember this for my thinking coach:" and it creates an inbox file. Your thinking coach picks it up at next session start.

### "I want to look up a recipe I've cooked before while cooking"

**Use Gemini or Claude.ai phone.**

Both surface your cooking coach's recipe files via vault. Gemini is faster and works better in the kitchen (voice-friendly). Ask:
> *"What did I cook with Japanese eggplant last time? How did it go?"*

Gemini can search `recipes/` and `sessions.md` and synthesize an answer.

### "I want to think through a hard decision I'm facing"

**Use Mac CLI (thinking coach) or Claude Desktop.**

Long-form reasoning benefits from the full thinking coach session on Mac:
- Coach reads your decisions/ folder
- Coach knows your mental model history
- Session writes to a proper decision journal entry
- Cross-domain observations surface (e.g., "this might affect your fitness schedule")

Claude Desktop is a reasonable second choice if you're on Windows or want a GUI.

### "I'm at a new restaurant and want to take notes for my vault"

**Use voice or Claude.ai phone.**

Dictate to Claude.ai: *"We're at Nico in Hayes Valley. Just had the beef tartare — raw egg, capers, really acidic. The bread service was exceptional, sourdough with cultured butter."*

Claude creates an inbox file. `inbox-triage` routes it to `Restaurants/sf/nico.md` at next Mac session.

Alternatively: drop a note in Inbox.md app if you have it on your phone's home screen. Works offline.

### "I want to do a weekly review"

**Use Mac CLI.**

Weekly review reads across all coaches, all inbox entries, all daily notes — it's a heavy read job. It needs the full filesystem access and the `weekly-review` skill.

```bash
brain
> run weekly review
```

### "I got workshop feedback on my writing and want to process it"

**Use Mac CLI (writing coach).**

This is the richest workflow: you paste the feedback, the coach reads `voice.md` and your pieces/ folder, then helps you triage which feedback is right vs. wrong vs. misidentified-symptom. The output goes to a `feedback/` file and updates the piece file.

This is a deep session — use the CLI.

---

## By device

### Mac, at desk, terminal open

Default to Mac CLI. The gap between CLI and other surfaces is largest here: auto-loading, skills, full filesystem, scheduled jobs. No reason to use a lighter surface when the full one is available.

### Mac, at desk, no terminal

Claude Desktop with mcp-obsidian. Full vault read/write without opening a terminal. Good for occasional check-ins or users who don't live in terminals.

### iPhone, on the go

Claude.ai phone project per coach. Pinned at the top of the project list. One tap to any coach. Use voice mode for hands-free.

### Android, on the go

Gemini. Native @Drive integration, voice mode, fast. Equal to Claude.ai phone for most day-to-day use; stronger for Calendar/Gmail tasks.

### Windows

Claude Desktop with mcp-obsidian is the primary option (CLI is Mac-only). For phone-side access, Claude.ai phone works the same as on iOS.

---

## Using multiple surfaces simultaneously

You can have Gemini, Claude.ai, and Claude Desktop all pointing at the same vault. They share the files.

**They don't conflict** — each surface reads the same canonical files. A session logged via Claude.ai phone (as an inbox file) gets integrated into canonical files the next time you run Mac CLI. Gemini's direct vault updates are reflected immediately if Drive Desktop is installed.

**Potential confusion**: if you have a session on Claude.ai phone *and* a session on Mac CLI the same day before Mac has synced, the phone session's inbox file won't be integrated yet. The Mac session won't see it until vault-pull-inbox runs. This is the append-only constraint at work — it's a ~5-minute lag, not a conflict.

**Rule of thumb**: at the end of any substantive multi-surface day, run Mac CLI once to pull all inbox files from phone and push a fresh snapshot. That keeps the system clean.

---

## The escalation ladder

When in doubt, think about the session's depth:

```
Quick capture, on-the-go?  →  Phone (Claude.ai or Gemini)
Medium session, GUI preferred?  →  Claude Desktop
Deep session, full vault context?  →  Mac CLI
Cross-coach synthesis or weekly review?  →  Mac CLI with brain alias
```

The vault is always the same. The surface changes what tools you have to interact with it.
