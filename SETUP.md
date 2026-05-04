# SETUP

How to set up your own GetBetterAt vault from scratch. Total time: ~30 minutes for foundation, ~10 more per coach you spawn.

## Prerequisites

- macOS (Linux/Windows: most works, but shell aliases + iOS app integration are mac+iOS-tested)
- Google account (for Drive connector and optional Drive Desktop sync)
- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code/setup) installed and authenticated
- (Optional) [Claude Desktop app](https://claude.ai/download) — useful but not required
- (Optional) [Obsidian](https://obsidian.md/download) — for visual editing of the vault
- (Optional) [Google Drive Desktop](https://www.google.com/drive/download/) — recommended for cleaner sync

## Step 1 — Clone the framework

```bash
git clone https://github.com/ashish-sadh/GetBetterAt.git ~/.GetBetterAt
```

This puts the framework (skills, templates, scripts) in `~/.GetBetterAt`. Your *vault* will live separately at `~/Documents/Vault/` (or in Drive Desktop's folder).

## Step 2 — Bootstrap your vault

```bash
~/.GetBetterAt/scripts/bootstrap.sh
```

The script will:
- Create vault directory at `~/Documents/Vault/` (or your chosen path)
- Copy templates for `_shared/`, `CLAUDE.md`, `.claude/skills/`
- Create empty `Daily/`, `Inbox.md`, `Ideas/`, `Projects/`, `Reading/`, `Archive/`
- Add shell aliases to your `~/.zshrc` (or `~/.bashrc`)
- Initialize cache files

## Step 3 — Authenticate Google Drive in Claude

In any Claude Code session, run:

```
/mcp
```

Select **claude.ai Google Drive** and complete the OAuth flow in your browser. This grants Claude Code read/write access to your Drive.

**Note**: when the consent screen appears, ensure you grant write/edit permissions, not just read-only.

## Step 4 — Spawn your first coach

In your terminal (with shell aliases loaded — open a new tab):

```
brain
```

In the resulting Claude session, say:

> spawn a [domain] coach

(e.g., `spawn a pole dance coach`, `spawn a cooking coach`, `spawn a thinking coach`)

The `spawn-coach` skill will:
1. Ask for coach name and domain specifics (interview format, ~5-10 min)
2. Create local folder `Coaches/GetBetterAt<Name>/` with template files
3. Create Drive folders (`Vault/<coach>/snapshots/`, `inbox/`, `days/`)
4. Add the new shell alias (e.g., `pole`, `cook`, `think`) to `~/.zshrc`
5. Generate initial snapshot and upload to Drive
6. Output the system prompt for your Claude.ai phone project

## Step 5 — Set up Claude.ai project for phone

For each coach, create a Claude.ai project:

1. Open **Claude.ai** (web or iOS app)
2. Verify Google Drive connector is enabled (Settings → Integrations)
3. Create new Project, name it (e.g., "Pole Coach")
4. Tap **Add instructions** (or "Custom instructions" depending on app version)
5. Paste the system prompt that `spawn-coach` output
6. Pin the project for one-tap access

## Step 6 — (Optional) Install Google Drive Desktop

This gives you bidirectional file sync, meaning Mac filesystem operations (delete, rename, restructure) propagate to Drive. Without it, Drive accumulates files forever.

1. Download from https://www.google.com/drive/download/
2. Install + sign in with your Google account
3. Choose **Mirror files** mode (NOT Stream)
4. Wait for initial sync

After install:
```bash
# Find Drive's mount path
ls ~/Library/CloudStorage/

# Move vault into Drive folder
mv ~/Documents/Vault ~/Library/CloudStorage/GoogleDrive-<email>/My\ Drive/

# Update VAULT env var in ~/.zshrc
# Change: export VAULT="$HOME/Documents/Vault"
# To:     export VAULT="$HOME/Library/CloudStorage/GoogleDrive-<email>/My Drive/Vault"

# Reload shell
source ~/.zshrc
```

## Step 7 — Test end-to-end

Round-trip test:

1. **Phone**: open Pole Coach project, ask "What's my current pole status?" → should reference your specifics
2. **Phone**: ask "Add 'split grip' to my vocabulary" → should create inbox file in Drive
3. **Mac**: open new terminal, type `pole` → should pull the inbox file, integrate "split grip"
4. **Mac**: check `~/Documents/Vault/Coaches/GetBetterAtPole/vocabulary.md` → entry should be there

If all three work, the system is fully operational.

## Step 8 — (Optional) Install Obsidian

For visual editing and graph view:

1. https://obsidian.md/download
2. Open Obsidian → "Open folder as vault" → select your Vault folder
3. Install community plugins (optional):
   - **Smart Connections** (semantic search)
   - **Templater** (file templates)
   - **Dataview** (queries across notes)

## Common setup issues

### "permission denied" when running scripts
```bash
chmod +x ~/.GetBetterAt/scripts/bootstrap.sh
```

### Shell aliases not loading
Make sure your shell config sources your aliases. Check `~/.zshrc` (or `~/.bashrc` for bash) for the aliases block. Open a new terminal tab to reload.

### Drive connector says "insufficient scopes"
Re-run `/mcp`, complete consent. If still failing, manage permissions at https://myaccount.google.com/permissions and re-add the connector.

### Phone Claude doesn't read snapshot
Check the Claude.ai project's system prompt has the correct Drive folder ID. Find your folder ID in `~/Documents/Vault/.claude/drive-config.json` after running `spawn-coach`.

---

## What's next

After setup:
- Use the coach. The first 5-10 sessions are the most awkward; fluency comes with use.
- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the system more deeply.
- See [docs/extending.md](docs/extending.md) to add custom skills or domain templates.
- Spawn additional coaches as you want them — `brain` then `spawn a cooking coach` etc.
