# GetBetterAt

A multi-coach personal AI system. Specialized AI coaches (pole, fitness, thinking, cooking, speaking, organized — whatever you want) backed by an Obsidian vault, talking to you across Mac CLI and phone via Claude.ai.

Built on append-only sync via Google Drive connector. No daemons required for the basic setup; bring Drive Desktop for cleaner restructuring.

---

## What you get

- **One vault, many coaches.** Each coach is a folder with its own profile, program, vocabulary, sessions, and persona. Shared user facts live in `_shared/` so you don't repeat yourself.
- **Two modes that work in lockstep**:
  - **Mac (powerful mode)** — Obsidian + Claude CLI. Edit anything, run skills, restructure freely.
  - **Phone (lightweight mode)** — Claude.ai with Google Drive connector. Voice or text, reads vault, writes captures.
- **Append-only sync via Google Drive.** Phone writes inbox messages; Mac integrates and pushes snapshots. Optional Drive Desktop install gets you bidirectional file sync and clean restructuring.
- **Self-improving coaches.** Built-in skills (`coach-evolve`, `coach-meta-review`) prompt each coach to refine its own persona and structure based on real use.

## How it feels

```
$ pole
Welcome back. Last session you drilled chopper holds — how's the trap?
Today's plan: shoulder mount conditioning + butterfly hip rotation.

> just got out of class. butterfly clicked on the right.

Logged. Noted right-side success on butterfly. Want to drill left next time?

> yes. also worked on shoulder mount, foot down version. couldn't keep scaps engaged.

Logged. Trap-protective scap engagement is a known stuck point — we'll spend
20 min off-pole on scap pulls before next attempt.
```

On phone, same coach, same context, voice mode, no paste-back.

## Quickstart

```bash
git clone https://github.com/ashish-sadh/GetBetterAt.git ~/.GetBetterAt
~/.GetBetterAt/scripts/bootstrap.sh
```

Then follow [SETUP.md](SETUP.md) for the manual steps:
1. Authenticate Claude with Google Drive (`/mcp` in Claude Code)
2. Create a Claude.ai project per coach with the system prompt template
3. (Recommended) Install Google Drive Desktop for bidirectional sync

You'll have your first coach (`pole`, `cook`, `think`, whatever you spawn) running in ~30 minutes.

## Architecture (one-liner)

```
Phone (Claude.ai + Drive connector) ↔ Drive (relay) ↔ Mac (Obsidian + Claude CLI)
                                          ↑
                           Append-only inbox + dated snapshots
```

Read [ARCHITECTURE.md](ARCHITECTURE.md) for the full design and why-it's-shaped-this-way.

## Why this exists

Generic chatbots don't know you. Coaches that know you compound knowledge over time — your moves, your patterns, your body, your goals. This framework gives you persistent memory of what you've learned, structured by domain, accessible from any device, with no vendor lock-in (it's all markdown).

Read [docs/why.md](docs/why.md) for the longer version.

## What's included

- **`skills/`** — Agent Skills that all coaches share: capture, sync, snapshot regeneration, weekly review, idea distillation, vault maintenance, coach evolution, coach spawning/retirement
- **`templates/`** — Generic templates for new coaches and shared infrastructure
- **`examples/`** — Sanitized example coaches (pole, cooking, thinking, fitness) you can copy and customize
- **`scripts/`** — Setup automation
- **`docs/`** — Architecture, design rationale, extending the system

## Status

**Active development.** Built originally for one user; framework being extracted for general use. APIs and conventions may evolve. Not 1.0 yet.

## License

MIT — do whatever, just don't blame me.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). New coach examples, skills, and domain templates welcome.

## Credits

Built collaboratively with Claude (Anthropic) by [@ashish-sadh](https://github.com/ashish-sadh).

Inspired by:
- Tiago Forte (Building a Second Brain)
- Andy Matuschak (evergreen notes)
- Linus Lee (knowledge graphs)
- The Obsidian community
