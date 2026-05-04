# Changelog

Documents major architecture decisions, capability additions, and breaking changes in the LifeOS framework. Newest first.

Detailed git history: `git log --oneline`

---

## 2026-05-04 — Skills polish pass

**What changed**: Four skills received substantive improvements:
- `vault-push-snapshot`: Added per-section character budgets (totaling ~8,000 chars) and an ordered 5-step compression algorithm for enforcing the 10 KB phone snapshot cap
- `vault-pull-inbox`: Added canonical inbox file format spec and a 4-level decision tree for malformed files (parseable, garbled, unrecognizable, Drive read failure)
- `coach-evolve`: Added item-application confirmation flow, lite-evolve path for newly spawned coaches (0–5 sessions), and explicit 8-item cap on proposals
- `spawn-coach`: Domain-specific onboarding interview rounds documented for all 6 supported domains (pole, fitness, thinking, speaking, writing, cooking)
- `vault-maintain`: Full 14-field `maintain-config.json` schema with defaults, units, and per-coach override support

**Why**: The initial skill specs had accurate algorithms but under-specified edge cases. The phone snapshot cap in particular had no compression guidance, leading to inconsistent behavior when snapshot files grew large.

---

## 2026-05-04 — Examples expansion

**What changed**: Five example coach domains fully populated with realistic sanitized content:

- `examples/cooking/` — `CLAUDE.md`, `profile.md`, 3 recipe files, `techniques/knife-skills.md`
- `examples/thinking/` — `CLAUDE.md`, `profile.md`, decision journal entry, two mental model files
- `examples/fitness/` — `CLAUDE.md`, `profile.md`, workout log, strength benchmarks
- `examples/speaking/` — `CLAUDE.md`, `profile.md`, talk debrief file, recurring theme tracker
- `examples/writing/` — `CLAUDE.md`, `profile.md`, `voice.md`, piece file through Draft 3

**Why**: The initial repo had only `examples/pole/` as a reference. New users forking for cooking or fitness had no starting point and ended up with generic coaches. Domain-specific structure (e.g., writing's `voice.md`, thinking's `decisions/`) requires showing — not just describing.

---

## 2026-05-04 — Launchd automation for scheduled consolidation

**What changed**: Added `com.lifeos.daily-11pm-consolidate.plist` — a macOS launchd plist that fires `daily-11pm-consolidate.sh` at 23:00 local time, logging to `~/.cache/lifeos-logs/`.

**Why**: `daily-consolidate` was wired as a skill that had to be invoked manually or at session end. For consistent end-of-day consolidation (critical to keeping phone snapshots current), background automation is more reliable than memory.

**Setup** (manual install step, not run by bootstrap):
```bash
cp .claude/scheduled/launchd/*.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.lifeos.daily-11pm-consolidate.plist
```

---

## 2026-05-04 — Bootstrap rewrite (8 bug fixes)

**What changed**: `scripts/bootstrap.sh` rewritten to fix new-user install failures:

1. `LIFEOS_REPO` was resolving to the `scripts/` directory instead of the repo root
2. Drive Desktop detection used hardcoded email; fixed to auto-detect via `~/Library/CloudStorage/GoogleDrive-*` glob
3. Skills symlink pointed to a non-existent `GetBetterAt` repo; fixed to `$LIFEOS_REPO/skills`
4. Drive Desktop absence was a hard error; downgraded to a warning (Drive Desktop is optional)
5. Vault creation from templates was missing; now creates vault scaffold if it doesn't exist
6. Shell aliases were not idempotent; fixed with guard checks
7. `$VAULT` env var was set inconsistently; now always sourced from the auto-detected Drive path
8. `bash -n` syntax error in heredoc quoting; fixed

**Why**: Multiple new users reported that `bootstrap.sh` failed on first run. The script had been developed in an environment where Drive Desktop and a specific vault structure already existed; fresh-Mac assumptions weren't tested.

---

## 2026-05-03 — SETUP_PHONE.md — paste-ready phone prompts

**What changed**: Added `SETUP_PHONE.md` with complete paste-ready system prompts for:
- Claude.ai phone project
- Gemini Advanced
- ChatGPT (with instructions plugin)
- Voice assistant wrappers
- OpenClaw (optional local alternative)

Each prompt includes the Drive folder structure and coach folder paths needed for phone-side reads and writes.

**Breaking change (2026-05-04 patch)**: The initial version included the author's personal Drive file IDs. These were replaced with clearly labeled placeholders (`YOUR_SNAPSHOTS_FOLDER_ID`, etc.) in a follow-up commit.

---

## 2026-05-03 — Drive Desktop adoption

**What changed**: Drive Desktop became the recommended installation path, documented in `docs/drive-desktop.md`.

**Why**: The original architecture relied solely on the Google Drive API connector (create-only, no delete, no overwrite). This created accumulation problems:
- Inbox files in Drive grow forever; no way to clean them up programmatically
- Canonical file changes on Mac don't propagate to Drive unless explicitly pushed
- Snapshot-indirection was required for phone to see current state

Drive Desktop (Google's macOS sync daemon in Mirror mode) adds filesystem-level Drive access: Mac can delete inbox files after processing, restructure folders, and have all canonical file changes automatically propagate within ~30 seconds.

The connector is still required for phone Claude.ai (which can only create files via API). Drive Desktop is a Mac-side enhancement only.

**Behavior difference**: With Drive Desktop, `$VAULT` points to `~/Library/CloudStorage/GoogleDrive-<email>/My Drive/Vault/`. Without it, `$VAULT` points to a local directory that must be manually synced via the connector. Bootstrap.sh auto-detects which path applies.

---

## 2026-05-03 — GetBetterAt → LifeOS rename

**What changed**: Project renamed from "GetBetterAt" to "LifeOS."

**Why**: "GetBetterAt" only captured the coach domains (pole, cooking, thinking). LifeOS also includes:
- Daily-life assistant (tasks, reminders, calendar context)
- Personal knowledge structure (People, Places, Restaurants, Events, Daily, Inbox, Ideas)
- Cross-device unified vault across Mac, phone, Gemini, ChatGPT
- AI surface abstraction layer (`_ai/*.md` recipes)

The narrow name was limiting how people understood what they were forking. LifeOS describes the full scope: a personal OS layer that lives in your Google Drive and talks through whichever AI surface you're on.

**Coach paths unchanged**: Coaches still live at `Vault/Coaches/GetBetterAt<Name>/` to preserve existing vault data for current users. Only the repo name and top-level product name changed.

---

## 2026-05-03 — Initial public release (GetBetterAt framework)

**What shipped**:

- 12 Agent Skills covering the full coach lifecycle: `vault-pull-inbox`, `vault-push-snapshot`, `obsidian-sync`, `spawn-coach`, `retire-coach`, `coach-evolve`, `coach-meta-review`, `vault-maintain`, `weekly-review`, `daily-consolidate`, `snapshot-regen`, `cross-domain-link`
- Generic coach template at `templates/coach-template/`
- Sanitized example: `examples/pole/` (aerial arts coach)
- Shared infrastructure templates: `_shared/profile.md`, `_shared/principles.md`, `_shared/schedule.md`
- Bootstrap script: `scripts/bootstrap.sh`
- Architecture documentation: `ARCHITECTURE.md`, `docs/append-only.md`, `docs/why.md`, `docs/extending.md`
- AI surface recipes: `_ai/claude-cli.md`, `_ai/claude-ai.md`, `_ai/gemini.md`, `_ai/chatgpt.md`, `_ai/openclaw.md`, `_ai/local-llm.md`, `_ai/voice-assistants.md`

**Core architectural decisions at launch**:

1. **Markdown-first**: all data is human-readable `.md` files. No database, no proprietary format. Files survive any tool change.

2. **Code in repo, data in Drive**: the framework (skills, templates, scripts) is in Git. Personal vault data never touches Git. This separation makes forking safe and keeps personal data private.

3. **Append-only phone writes**: phone Claude.ai can only create new inbox files (Drive API is create-only from the connector). It cannot edit Mac canonical files directly. Mac Claude consolidates inbox writes at session start. This is a constraint from the Drive API, not a design choice — but it turns out to be a good architectural separation anyway.

4. **Coach per domain, not one general assistant**: each coach has domain-shaped files (`vocabulary.md` for pole, `recipes/` for cooking, `decisions/` for thinking). Cramming domains together produces generic advice. Separation enables depth.

5. **Snapshot indirection for phone**: rather than phone reading 6+ canonical files at session start, Mac pushes a single compressed snapshot to Drive. Phone reads one file. This was the original solution to the Drive connector's lack of delete/update support; Drive Desktop makes it optional but the pattern remains useful for performance.
