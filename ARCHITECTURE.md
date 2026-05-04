# Architecture

A practical guide to how this system actually works under the hood. Read this if you want to extend the framework, build new skills, or understand the design tradeoffs.

---

## The core mental model

**Three layers, one source of truth.**

```
┌─ THE BRAIN: VAULT (markdown files) ──────────────────┐
│                                                       │
│  ~/Documents/Vault/  (or in Drive Desktop folder)     │
│  ├── _shared/                  global user facts      │
│  ├── Coaches/                  one folder per coach   │
│  ├── Daily/, Inbox.md, Ideas/  raw thinking           │
│  ├── Projects/, Reading/       structured notes       │
│  └── .claude/skills/           reusable behaviors     │
│                                                       │
└──────────────────────────────────────────────────────┘
                ↑                            ↑
                │                            │
┌─ MAC ──────────┴──┐         ┌──────────────┴── PHONE ─┐
│                   │         │                          │
│ Obsidian          │         │ Claude.ai (web/iOS)      │
│ Claude CLI        │         │ + Google Drive connector │
│ Aliases:          │         │ One project per coach    │
│ pole, brain, etc. │         │ Voice or text            │
│                   │         │                          │
│ Reads/writes      │         │ Reads canonical files    │
│ canonical files   │         │ Writes append-only       │
│ directly          │         │ inbox files              │
│                   │         │                          │
└───────────────────┘         └──────────────────────────┘
```

**Vault = the brain.** Mac is the powerful editor. Phone is the lightweight conversation surface. Drive is the message bus between them.

---

## The append-only constraint

The Google Drive connector that Claude uses can only **create** files, not **update** or **delete** them. This shapes everything:

- Phone Claude writes new "inbox" files instead of updating canonical ones
- Mac Claude integrates inbox files into canonical files locally
- Mac pushes a fresh "snapshot" file to Drive that phone reads as bootstrap context
- Old snapshots and inbox files accumulate in Drive (harmless; markdown is tiny)

This sounds awkward but it produces a clean **append-only history**: nothing ever silently overwrites anything. You can always reconstruct what was said when.

If you install Google Drive Desktop (recommended), Mac filesystem operations propagate to Drive — meaning Mac can clean up old inbox/snapshots over time. Without Drive Desktop, you do periodic manual cleanup via Drive web (5 min/quarter).

Read [docs/append-only.md](docs/append-only.md) for the full constraint analysis.

---

## A coach is a folder

```
Coaches/GetBetterAtPole/
├── CLAUDE.md           Coach persona + read/update protocol (auto-loaded by `pole` alias)
├── profile.md          Domain-specific user state (moves, asymmetries, fears)
├── program.md          Current training program
├── vocabulary.md       Move/concept glossary
├── sessions.md         Append-only session log
├── context-snapshot.md Phone-ready digest (regenerated periodically)
└── inbox/              Where phone Claude drops conversation captures
```

Different domains shape this differently. A cooking coach has `recipes/`, `techniques/`, `ingredients/`. A thinking coach has `decisions/`, `models/`, `journal/`. The invariants: `CLAUDE.md`, `profile.md`, `sessions.md`, `context-snapshot.md`.

---

## How a Mac CLI session flows

```
$ pole          ← shell alias

# alias does: cd to coach folder + run claude
# CLAUDE.md auto-loads

# Step 0: Sync from phone
# vault-pull-inbox skill runs
#   → reads Drive inbox/ via connector
#   → integrates new entries into local files
#   → marks them processed

# Step 1: Read context
# Coach reads:
#   _shared/profile.md
#   _shared/principles.md
#   Coaches/<coach>/{profile, program, vocabulary, sessions, context-snapshot}.md

# Step 2: Conversation
# User chats; coach responds with context

# Step 3: Update + push
# obsidian-sync skill writes session updates to local files
# snapshot-regen regenerates context-snapshot.md
# vault-push-snapshot uploads new dated snapshot to Drive
```

---

## How a phone Claude.ai session flows

```
User taps "Pole Coach" project (pinned)

# Project's system prompt instructs:
# 1. Use Drive connector to find LATEST snapshot
#    in <coach>/snapshots/ folder (sort by createdTime desc)
# 2. Read that file via read_file_content
# 3. Follow its persona and protocol

# Conversation happens (text or voice mode)

# At end:
# 4. Use create_file to write a new inbox file
#    Vault/Coaches/<coach>/inbox/YYYY-MM-DDTHH-MM-<topic>.md
# 5. File contains structured update sections that
#    Mac will integrate next session
```

---

## Skills

Skills (`.claude/skills/<name>/SKILL.md`) are reusable behaviors invoked by name when relevant. Loaded automatically by Claude Code.

| Skill | Purpose |
|---|---|
| `obsidian-sync` | Write session updates back to vault files |
| `snapshot-regen` | Regenerate `context-snapshot.md` from current state |
| `vault-pull-inbox` | Pull phone inbox files from Drive, integrate into local files |
| `vault-push-snapshot` | Upload fresh dated snapshot to Drive |
| `daily-consolidate` | Synthesize today's inbox into one day file per coach |
| `weekly-review` | Cross-coach synthesis of past 7 days |
| `idea-distill` | Process Inbox.md and Ideas/ for patterns |
| `vault-maintain` | Detect and propose structural cleanup (split big files, archive old) |
| `coach-evolve` | Per-coach self-review every ~10 sessions |
| `coach-meta-review` | Quarterly: coach refines its own CLAUDE.md |
| `spawn-coach` | Scaffold a new coach end-to-end |
| `retire-coach` | Archive coach + remove alias |

---

## Three layers of "the coach gets better"

**Layer 1 — Per-conversation extraction** (every session)
Phone writes inbox; Mac integrates. New move → vocabulary entry. New observation → profile note.

**Layer 2 — Periodic self-review** (~every 10 sessions, via `coach-evolve`)
Coach reads its own session history and proposes:
- *"You've cooked rice 4 times. Want a dedicated `recipes/rice.md`?"*
- *"You've mentioned 'salt taste off' 3 times. Add to patterns?"*

**Layer 3 — Quarterly meta-review** (via `coach-meta-review`)
Coach reads its own CLAUDE.md against actual sessions and proposes persona refinements:
- *"My CLAUDE.md says 'encouraging tone' but my actual messages are direct. Update."*
- *"I track 'rating' in session log but you stopped giving ratings 6 weeks ago. Drop the field."*

This is what makes the coach genuinely your coach over time, not a generic template.

---

## Vault root vs coach root

The vault root has its own `CLAUDE.md` that handles:
- Vault map (what's where)
- Top-level routing (suggest specific coach for domain questions)
- Cross-coach observations (`brain` alias)
- Calling `vault-pull-inbox` for all coaches at session start
- Calling `vault-maintain` periodically

Coach roots have their own `CLAUDE.md` for:
- Coach persona (voice, style)
- Per-coach reading protocol
- Per-coach update protocol
- Per-coach restructuring rules

---

## Sync architectures: connector-only vs. Drive Desktop

| Concern | Connector-only | + Drive Desktop |
|---|---|---|
| Mac↔Drive sync of canonical files | ❌ Mac files local; pushed via snapshot | ✅ Bidirectional filesystem mirror |
| Phone↔Drive sync | ✅ via connector | ✅ via connector (unchanged) |
| Phone create | ✅ create_file | ✅ |
| Phone read | ✅ read_file_content | ✅ |
| Phone update existing file | ❌ creates duplicate | ❌ same |
| Phone delete | ❌ no tool | ❌ no tool |
| Mac update local files | ✅ filesystem | ✅ filesystem |
| Mac delete files (and reflect in Drive) | ❌ Drive accumulates forever | ✅ filesystem delete propagates |
| Mac restructure (rename/move) | ❌ Drive doesn't see changes | ✅ filesystem ops propagate |
| Drive cleanup of old snapshots/inbox | Manual via Drive web | ✅ Mac filesystem delete |
| Daemon running | None | Drive Desktop (~50 MB RAM) |

Recommendation: **install Drive Desktop**. Both work; Drive Desktop is meaningfully cleaner.

---

## Speed budgets

To keep the system fast even after years of use:

| File | Target max | Action when exceeded |
|---|---|---|
| `context-snapshot.md` | 10 KB | Compress older sessions; link to full files instead of inlining |
| `sessions.md` | 60 entries (~30-60 KB) | Archive oldest quarter to `sessions/<quarter>.md` |
| `vocabulary.md` | 25 entries | Split by category (`vocab/<category>.md`) |
| Drive inbox/ per coach | 50 files | Daily-consolidate; consider Drive web cleanup |
| Mac session-start file reads | 7 files (snapshot + 6 canonical) | Lazy-load — only read what conversation needs |

The `vault-maintain` skill enforces these budgets when invoked.

---

## File-naming conventions

- Daily notes: `YYYY-MM-DD.md`
- Snapshots: `snapshot-YYYY-MM-DDTHH-MM.md`
- Inbox files: `YYYY-MM-DDTHH-MM-<topic>.md`
- Day files: `YYYY-MM-DD.md`
- Vocab entries (when split): `<category>.md` or `<entry>.md`
- Recipe files (cooking): `<dish-kebab-case>.md`
- Wikilinks: `[[note-name]]` (Obsidian convention)

---

## Privacy model

Everything is on your hardware (vault on Mac) and your Drive (snapshots, inbox). No third-party servers. The Anthropic API processes content in conversations but doesn't retain it as memory; the vault is your memory.

The Google Drive connector authenticates with your account; Anthropic accesses Drive as you, scoped to what you've granted. You can revoke at any time via Google account settings.

When in doubt: review what's in `_shared/profile.md` — that's the most-read file. Anything sensitive that you don't want in coaching context, keep elsewhere.

---

## Future evolution

Likely additions:
- Voice memo → vault automation (record on phone, Whisper transcribes, Claude integrates)
- Shared coaches across multiple users (partner system, family fitness, team)
- Plugin system for non-text data (images, audio, video coaching)
- Local LLM fallback for fully-offline coach access

None of these are in scope for v1.
