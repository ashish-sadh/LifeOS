# LifeOS

A personal AI knowledge OS. Specialized AI coaches, daily-life assistant, and structured memory across domains (people, places, restaurants, events) — all in markdown, in your Google Drive, accessible from any AI surface.

```
LifeOS/
├── _shared/                Global facts about you
├── GetBetterAt/            Coaches (growth-oriented agents)
│   ├── Pole/, Cooking/, Thinking/, Fitness/, Speaking/, Organized/
├── Assistant/              Daily life logistics
├── People/, Places/, Restaurants/, Events/
└── Daily/, Inbox.md, Ideas/, Projects/, Reading/
```

Mac CLI for deep work. Phone Claude.ai for on-the-go. Gemini, ChatGPT, OpenClaw — any AI surface that can read your Drive can be a coach.

## What you get

- **Specialized coaches per domain**, with persistent personalized memory that compounds over months
- **Self-improving personas** — coaches refine their own instructions based on what works for you
- **Cross-device unified** — Mac CLI + phone Claude.ai + Gemini all reading the same vault
- **Append-only sync via Google Drive** — no daemon required for basic use; install Drive Desktop for cleaner restructuring
- **Markdown-based, portable forever** — no vendor lock-in
- **Structured personal memory** — people, places, restaurants, events, all cross-linked

## Quickstart

```bash
git clone https://github.com/ashish-sadh/LifeOS.git ~/workspace/LifeOS
~/workspace/LifeOS/scripts/bootstrap.sh
```

Then:

1. Authenticate Google Drive in Claude (`/mcp` in any Claude Code session)
2. Spawn your first coach (`brain` then "spawn a [domain] coach")
3. Set up Claude.ai phone Project per coach (recipe in `_ai/claude-ai.md`)
4. (Recommended) Install Google Drive Desktop for full sync

Detailed walkthrough: [SETUP.md](SETUP.md)

## Repository contents

```
LifeOS/                          THIS REPO
├── README.md, ARCHITECTURE.md, SETUP.md, CONTRIBUTING.md
├── LICENSE                      MIT
│
├── skills/                      Agent Skills (12 of them)
│   ├── obsidian-sync/, snapshot-regen/, vault-pull-inbox/, vault-push-snapshot/
│   ├── daily-consolidate/, weekly-review/, idea-distill/, vault-maintain/
│   ├── coach-evolve/, coach-meta-review/, spawn-coach/, retire-coach/
│
├── templates/                   Reusable templates
│   ├── _shared/                 Profile/principles/schedule starter
│   └── coach-template/          Generic coach scaffold
│
├── examples/                    Sanitized example coaches
│   ├── pole/, cooking/, thinking/, fitness/, speaking/
│
├── _ai/                         Per-AI-surface setup recipes
│   ├── claude-cli.md, claude-ai.md, gemini.md
│   ├── chatgpt.md, openclaw.md, local-llm.md, voice-assistants.md
│
├── _system/                     Architectural journal
│   └── architecture.md
│
├── .claude/                     Claude Code config
│   ├── scheduled/               Background jobs (launchd-driven)
│   └── settings.json
│
├── scripts/
│   └── bootstrap.sh             Setup automation
│
└── docs/                        Deep-dives
    ├── why.md, append-only.md, drive-desktop.md, extending.md
```

## Personal data lives in Google Drive

This repo holds the framework — code, templates, examples. Your actual vault content (your profile, sessions, daily notes, etc.) lives at `My Drive/LifeOS/` on your Drive (synced to Mac via Drive Desktop). It's never in Git.

## Architecture in one diagram

```
┌─── Personal data (Google Drive) ─────────────────────┐
│  My Drive/LifeOS/                                     │
│  - All markdown content (profile, sessions, etc.)     │
│  - Per-coach CLAUDE.md (customized personas)          │
│  - Phone-written inbox files                          │
│  - Mac-pushed snapshots                               │
└──────────────────────────────────────────────────────┘
        ↑                   ↑                   ↑
        │                   │                   │
   Mac filesystem       Drive connector     Drive web/app
   (via Drive Desktop)  (Claude.ai phone)   (browse, search)
        ↑                   ↑
        │                   │
   ┌────┴───┐         ┌─────┴──────┐
   │ Mac CLI│         │  Phone     │
   │ + Skills│         │  Claude.ai │
   │ + Scheduled       │  (or Gemini,│
   │   jobs │         │   ChatGPT) │
   └────────┘         └────────────┘
```

## How coaches improve over time

Three layers of refinement, run on different cadences:

1. **Per-conversation** (every session): Phone writes inbox → Mac integrates into canonical files
2. **Per-10-sessions** (`coach-evolve` skill): Coach reads its own history; proposes content extractions, vocabulary additions, profile refinements
3. **Per-quarter** (`coach-meta-review` skill): Coach reviews its own CLAUDE.md against actual sessions; proposes self-corrections to its own persona

Plus scheduled background work: daily morning briefs, weekly research, monthly audits. Output goes to `proposals/` for user review.

## Cross-domain power

The system's value emerges from cross-references:

- *"Lunch with [[People/alex-smith]] tomorrow at [[Restaurants/sf/shizen]] — last time you tried omakase. Then pole class at [[Places/sf-pole-and-dance]] — coach says shoulder mount conditioning week 1."*

This is what generic AI assistants can't do. They have no memory of your Alex, your Shizen, your pole instructor.

## Status

**Active development.** Built originally as one user's personal install; framework being refined for general use. APIs and conventions may evolve.

## License

MIT — fork freely, customize for yourself, contribute back if useful.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). New coach domain examples, skills, and AI surface recipes welcome.

## Inspiration

- Tiago Forte (Building a Second Brain)
- Andy Matuschak (evergreen notes)
- Linus Lee (knowledge graphs as cognitive prosthetics)
- The Obsidian community
- Personal AI experiments by power users in 2024-2026
