# LifeOS — Ralph Fix Plan

Tasks for autonomous improvement of LifeOS framework. Ralph picks one per loop, implements it, commits, marks done.

## High Priority — improve onboarding and core docs

- [x] Add a "Getting Started in 15 minutes" section near the top of README.md with a concrete first-coach walkthrough
- [x] Add troubleshooting FAQ to SETUP.md (common Drive Desktop issues, connector permission errors, alias not loading, etc.)
- [x] Verify `scripts/bootstrap.sh` runs cleanly on a fresh Mac — read through carefully, check for assumptions about user's email, verify all paths use $VARS not hardcoded, ensure idempotency
- [x] Make sure `SETUP_PHONE.md` has correct paste-ready prompts; verify file IDs are clearly labeled as "your IDs will differ"
- [x] Add a `CHANGELOG.md` documenting major architecture decisions (Vault → LifeOS rename, Drive Desktop adoption, etc.)

## High Priority — example coaches

- [x] Fully populate `examples/cooking/` — add `CLAUDE.md`, `profile.md` template, and 2-3 sample recipe files showing the recipes/ folder pattern
- [x] Fully populate `examples/thinking/` — add `CLAUDE.md`, `profile.md` template, sample decision/model files
- [x] Add `examples/fitness/` — strength + mobility focus, distinct from pole
- [x] Add `examples/speaking/` — public speaking / communication coach with talks/ folder pattern
- [x] Add `examples/writing/` — creative writing coach (different from cooking but similar shape)

## Medium Priority — skills polish

- [x] Review each `skills/*/SKILL.md` for clarity. Fix any with vague triggers or missing edge cases
- [x] `vault-pull-inbox` skill: add explicit handling for when phone-written inbox files are malformed (missing sections, escaped markdown, etc.)
- [x] `vault-push-snapshot` skill: clarify the snapshot template; ensure size cap (10 KB) is enforced
- [x] `coach-evolve` skill: add example output report so users know what to expect
- [x] `spawn-coach` skill: document the onboarding interview round structure per domain
- [x] `vault-maintain` skill: define the threshold-config.json schema clearly

## Medium Priority — new skills

- [x] Add `coach-research` skill that web-searches for new info in coach's domain and proposes additions
- [x] Add `inbox-triage` skill — for processing Inbox.md (vault root) entries into proper homes
- [x] Add `cross-domain-link` skill — finds opportunities to wikilink between People/Places/Events/Restaurants/Coaches

## Medium Priority — AI surface recipes

- [ ] `_ai/gemini.md`: try the actual setup, document quirks discovered
- [ ] `_ai/chatgpt.md`: same — actual test, real screenshots/quirks
- [ ] `_ai/openclaw.md`: when OpenClaw is installed and tested, document the real config (currently aspirational)
- [x] `_ai/claude-desktop.md`: write recipe for using Claude Desktop with mcp-obsidian, including config snippet

## Medium Priority — domain templates

- [x] Add `templates/people-template.md` — standardize how People/<person>.md should look
- [x] Add `templates/places-template.md`, `templates/restaurants-template.md`, `templates/events-template.md`
- [x] These should match what's in `examples/` but be cleaner standalone templates

## Low Priority — docs deep-dives

- [x] `docs/cross-domain-power.md` — concrete worked examples of the cross-domain intelligence
- [x] `docs/multi-surface-strategy.md` — when to use which AI surface, real usage patterns
- [x] `docs/cost.md` — honest cost analysis: API tokens, Drive storage, OpenClaw, etc.
- [x] `docs/privacy.md` — what data is where, who can see what, how to make it more private

## Low Priority — quality

- [x] Add `shellcheck` lint — installed shellcheck, fixed 3 real warnings in bootstrap.sh: SC2010 (ls|grep → glob loop), SC2088 (tilde in quotes → $HOME), SC2155 (declare+assign together → separate)
- [x] Run `bash -n` syntax check on all `.sh` files; fix any errors — all 5 scripts pass (bootstrap.sh + 4 scheduled)
- [x] Standardize reading protocols across all coach `CLAUDE.md` files — fixed eager pre-read anti-pattern (7 files → 2 bootstrap files + lazy-load) in all 6 examples and the template
- [ ] Fix `.claude/scheduled/` scripts: all 4 scripts hardcode `asheesh.sadh@gmail.com` in the LIFEOS path. Must use `$VAULT` instead. Additionally, `daily-11pm-consolidate.sh`, `daily-08am-brief.sh`, and `weekly-sun-10am-research.sh` reference `GetBetterAt/` instead of `Coaches/`. Pattern: replace `LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"` with `if [ -z "${VAULT:-}" ]; then exit 1; fi; LIFEOS="$VAULT"` and update all `GetBetterAt/` references to `Coaches/`.

## Low Priority — community / contribution

- [x] Add `CODE_OF_CONDUCT.md`
- [x] Add issue templates in `.github/ISSUE_TEMPLATE/` (new-coach-domain.md, new-skill.md, bug-report.md)
- [x] Add PR template in `.github/PULL_REQUEST_TEMPLATE.md`

## Completed

- [x] Initial framework + 12 skills + Pole example
- [x] Architecture docs (ARCHITECTURE, append-only, drive-desktop, why)
- [x] Public GitHub repo at ashish-sadh/LifeOS
- [x] LifeOS rename from GetBetterAt
- [x] SETUP_PHONE.md with paste-ready prompts
- [x] Drive Desktop integration documented

## Notes for Ralph

- This list is not in strict priority order — pick what's most impactful now, mark it done, log learnings
- When you discover a new task while doing one, append to the appropriate section
- If you think the priority of a section is wrong, propose a reorder in your response
- After 3-5 tasks completed in a category, suggest the user re-prioritize
- Don't bloat — prefer fewer, deeper improvements over many shallow ones
- When in doubt, prioritize: (a) onboarding, (b) examples, (c) docs, (d) skills polish, (e) new skills

## New tasks discovered this loop

- [x] `examples/pole/` is missing `sessions.md`, `program.md`, `progressions/` — the other 5 examples are more complete; pole is the canonical reference so should match their depth
- [x] `ARCHITECTURE.md` skills table is stale — inbox-triage, cross-domain-link, and coach-research are new skills not listed in it; also corrected the speed budget row (was "7 files", now "2 bootstrap files")
- [x] `templates/_shared/` templates — already existed from initial commit (`profile.md`, `principles.md`, `schedule.md`); task is complete
- [x] `examples/pole/context-snapshot.md` — add sample context snapshot showing the 10 KB phone-bootstrap format

## Architecture invariants (don't break these)

- Code in this repo, data in Drive
- Markdown-first
- Skills are `.claude/skills/<name>/SKILL.md` with frontmatter
- Coach folders follow `examples/<domain>/` pattern
- AI surface recipes follow `_ai/<surface>.md` pattern
- All shell scripts should be POSIX-compatible where possible (or document bash dependency)
