# Claude Code CLI (Mac) — Surface Recipe

The primary, most-capable surface. Has full filesystem access; runs Agent Skills; runs scheduled jobs.

## Pre-requisites

- macOS
- Claude Code CLI installed (`claude --version` works)
- Drive Desktop installed (recommended) — vault at `~/Library/CloudStorage/.../LifeOS/`
- Shell aliases configured (added by bootstrap.sh)

## How it works

1. You type a coach alias: `pole`, `cook`, `assist`, `brain`, etc.
2. The alias `cd`s into the right folder + runs `claude --dangerously-skip-permissions`
3. Claude Code auto-loads `CLAUDE.md` from the current directory
4. CLAUDE.md instructs the coach's reading protocol, update protocol, persona

## Capabilities

- Full filesystem read/write (via Read, Write, Edit tools)
- Bash for any shell operation (mv, rm, mkdir, find, grep, etc.)
- Agent Skills (`.claude/skills/`) auto-discovered and invocable
- Scheduled jobs (via launchd plists in `~/Library/LaunchAgents/`)
- Web search (via WebSearch tool)
- Drive connector (via `/mcp` for cross-Drive operations)
- MCP servers (e.g., mcp-obsidian if installed)

## Adding a new coach

```bash
brain
> spawn a [domain] coach
```

The `spawn-coach` skill handles end-to-end creation: folder structure, CLAUDE.md, onboarding interview, alias addition, initial snapshot, phone system prompt output.

## Maintenance

```bash
brain
> run vault-maintain
```

Or auto-suggested at session start if last run > 7 days.

## Scheduled jobs

See `LifeOS/.claude/scheduled/` for shell scripts and `~/Library/LaunchAgents/` for plists. They run:
- Daily 8am: morning brief
- Daily 11pm: consolidate
- Weekly Sun 9am: review
- Weekly Sun 10am: research per coach
- Bi-weekly: vault-maintain
- Monthly: audit
- Quarterly: meta-review per coach

Output → `LifeOS/proposals/`. User reviews next session.

## Updating the persona

Edit `LifeOS/CLAUDE.md` (top-level) or `LifeOS/GetBetterAt/<Coach>/CLAUDE.md` directly. Saved instantly. Next session, Claude auto-loads the new version.

## Common issues

| Symptom | Fix |
|---|---|
| Alias not found | Open new terminal tab, OR `source ~/.zshrc` |
| Wrong folder opens | Check `echo $LIFEOS` |
| Drive sync slow | Check Drive Desktop sync status |
| Skills not invoked | Verify `.claude/skills/<name>/SKILL.md` exists |
