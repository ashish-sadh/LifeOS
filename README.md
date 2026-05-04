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

## Getting started in 15 minutes

By the end of this walkthrough you'll have a working cooking coach: persistent memory of your kitchen, your skill level, your goals — available on your Mac CLI and your phone.

**Prerequisites**: Claude Code CLI installed and authenticated, a Google account.

### 1. Clone and bootstrap (~2 min)

```bash
git clone https://github.com/ashish-sadh/LifeOS.git ~/workspace/LifeOS
~/workspace/LifeOS/scripts/bootstrap.sh
```

The bootstrap script creates your vault at `~/Documents/Vault/`, copies skill files into `.claude/`, and adds shell aliases to `~/.zshrc`. Open a new terminal tab when it's done.

### 2. Authenticate Google Drive (~2 min)

In any Claude Code session:

```
/mcp
```

Select **claude.ai Google Drive** and complete the OAuth flow in your browser. When the consent screen appears, grant write permissions (not just read-only).

### 3. Spawn a cooking coach (~8 min)

Open a terminal and type:

```
brain
```

In the resulting Claude session, say:

> spawn a cooking coach

The `spawn-coach` skill runs an onboarding interview (~5-10 questions). For a cooking coach it'll ask things like:

- What does "cooking better" mean to you — weeknight speed, dinner parties, mastering a technique?
- What's your current level? What trips you up most?
- Dietary context? Who are you usually cooking for?
- Equipment gaps worth noting?

Answer honestly — this is what the coach will know about you from day one. When the interview finishes, it:

1. Creates `~/Documents/Vault/Coaches/GetBetterAtCooking/` with your personalized `profile.md`, `sessions.md`, etc.
2. Adds the `cook` alias to `~/.zshrc`
3. Uploads a context snapshot to Drive
4. Outputs a system prompt for your phone project

### 4. Test your Mac coach (~1 min)

Open a new terminal tab (to pick up the new alias), then:

```
cook
```

Ask it something real:

> I have chicken thighs, some leftover rice, and about 30 minutes. What should I make?

It will reference your profile — your kitchen setup, your skill level, your constraints. It's not a generic recipe bot.

### 5. Set up phone access (~2 min)

On your phone (Claude.ai iOS/Android):

1. Settings → Integrations → enable Google Drive
2. Create a new Project, name it "Cooking Coach"
3. Paste the system prompt that `spawn-coach` outputted
4. Pin the project for one-tap access

Now you can snap a photo of your fridge while grocery shopping and get a meal plan that knows your kitchen.

---

That's it. Spawn more coaches the same way: `brain` → "spawn a [domain] coach". Each gets its own alias, its own Drive folder, its own phone project.

Full setup guide with Drive Desktop sync, Obsidian integration, and troubleshooting: [SETUP.md](SETUP.md)

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
