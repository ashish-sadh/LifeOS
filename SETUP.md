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
git clone https://github.com/ashish-sadh/LifeOS.git ~/workspace/LifeOS
```

This puts the framework (skills, templates, scripts) in `~/workspace/LifeOS`. Your *vault* will live separately at `~/Documents/Vault/` (or in Drive Desktop's folder).

## Step 2 — Bootstrap your vault

```bash
~/workspace/LifeOS/scripts/bootstrap.sh
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

## Troubleshooting

### bootstrap.sh

**"permission denied" when running bootstrap.sh**
```bash
chmod +x ~/workspace/LifeOS/scripts/bootstrap.sh
```

**bootstrap.sh ran but nothing seems to have happened**
Check if it exited early. Run it again — it's idempotent. Look for error output. If the vault directory already exists it will skip creating it, which is correct.

**bootstrap.sh created files in the wrong place**
The script uses `$VAULT` if set, or defaults to `~/Documents/Vault`. If you wanted a different location, set `VAULT` before running:
```bash
export VAULT="$HOME/Library/CloudStorage/GoogleDrive-you@gmail.com/My Drive/Vault"
~/workspace/LifeOS/scripts/bootstrap.sh
```
Then make sure `$VAULT` is set the same way in `~/.zshrc` so aliases work in future sessions.

---

### Shell aliases

**`brain`, `cook`, `pole` — command not found**

Two likely causes:

1. You're in the same terminal session where you ran bootstrap. Shell config is only reloaded when you open a new tab or run `source ~/.zshrc`. Open a new tab and try again.

2. bootstrap.sh wrote to `~/.zshrc` but you're using bash. Check which shell is your default:
   ```bash
   echo $SHELL
   ```
   If it's `/bin/bash`, copy the aliases block from `~/.zshrc` into `~/.bashrc` (or `~/.bash_profile` on older macOS).

**Alias is there but opens Claude in the wrong directory**
Each alias is `cd $VAULT && claude`. If `$VAULT` isn't set (e.g., it's not in `~/.zshrc`), this silently opens Claude in `~` instead. Check:
```bash
echo $VAULT
```
If empty, add `export VAULT="<your vault path>"` to `~/.zshrc` and reload.

---

### Google Drive connector

**"insufficient scopes" or "unauthorized" error in Claude**
The connector was granted read-only permissions during the OAuth flow. Re-run `/mcp` in a Claude Code session, remove the existing Drive connector, and re-add it — on the consent screen, make sure to grant edit/write access, not just view.

If still failing after re-auth:
1. Go to https://myaccount.google.com/permissions
2. Find "Claude.ai" and revoke it
3. Re-run `/mcp` and complete a fresh OAuth flow

**Connector authenticated but Claude can't find a specific file**
Drive connector searches your My Drive. If your vault is in a Shared Drive (not My Drive), the connector may not see it. Move the vault folder to My Drive, or check whether your connector version supports Shared Drives.

**Connector works on Mac but phone Claude can't read Drive files**
Phone Claude.ai uses a separate OAuth grant. In the Claude.ai mobile app: Settings → Integrations → verify Google Drive is connected. If it shows connected but files aren't loading, disconnect and reconnect.

---

### Google Drive Desktop

**Can't find the Drive Desktop mount point**
```bash
ls ~/Library/CloudStorage/
```
The folder is named `GoogleDrive-<your-email>`. If this directory doesn't exist, Drive Desktop isn't running — check the menu bar icon or relaunch it from Applications.

**Chose "Stream" mode instead of "Mirror" — how to fix**
Stream mode keeps files in the cloud by default; Mirror mode syncs a full local copy. LifeOS needs local files because Claude Code reads from the filesystem.

To switch: Google Drive menu bar icon → Preferences → Google Drive tab → switch to "Mirror files". Wait for the initial re-sync (can take several minutes for large drives).

**Vault moved to Drive but `$VAULT` still points to old location**
Edit `~/.zshrc`:
```bash
# Change this:
export VAULT="$HOME/Documents/Vault"
# To this (adjust email and path):
export VAULT="$HOME/Library/CloudStorage/GoogleDrive-you@gmail.com/My Drive/Vault"
```
Then reload: `source ~/.zshrc`. Verify with `echo $VAULT`.

**Drive Desktop not starting on login**
System Settings → General → Login Items → add Google Drive to the list.

---

### spawn-coach

**"drive-config.json not found" or Drive-related error during spawn**
The `spawn-coach` skill writes to Drive during setup. Make sure you've completed Step 3 (Drive connector auth via `/mcp`) before spawning. Run `/mcp` in the `brain` session if you haven't.

**spawn-coach ran but no new alias was added**
Open a new terminal tab to reload `~/.zshrc`. If the alias still isn't there, check whether `spawn-coach` completed successfully — it should have printed a system prompt for your phone project. If it exited early, re-run `brain` and say "spawn a [domain] coach" again; the skill is designed to be re-runnable.

**Want to re-spawn a coach (replace existing)**
Say `spawn a cooking coach` again. The skill will ask whether to overwrite existing files. Say yes. Profile.md will be preserved unless you explicitly tell it to reset.

---

### Phone / Claude.ai

**Phone Claude references wrong or stale info**
The phone project reads from a snapshot file in your Drive. If the snapshot hasn't been pushed recently, phone Claude is working from old data. On your Mac, type the coach alias and say "push a snapshot" or invoke the `vault-push-snapshot` skill.

**System prompt in phone project has placeholder file IDs like `<FOLDER_ID>`**
The `spawn-coach` skill outputs a system prompt with your real Drive folder IDs substituted in. If you see angle-bracket placeholders, the skill may not have completed the Drive upload step. Re-run `spawn-coach` from `brain`. Check `~/.claude/drive-config.json` for the real IDs.

**Phone writes an inbox note but Mac doesn't pick it up**
The inbox file lives at `Vault/Coaches/GetBetterAt<Name>/inbox/` in Drive. On Mac, `vault-pull-inbox` downloads it. This only runs when you open a coach session — it's not a background daemon. Next time you type the coach alias, the inbox will be pulled automatically.

If Drive Desktop is installed and syncing, the file should appear in your local vault too — check `$VAULT/Coaches/GetBetterAt<Name>/inbox/`.

**Phone Claude ignores the system prompt or acts generic**
Claude.ai projects have a character limit on the system prompt (~10K characters). If `spawn-coach` generated a very long prompt, it may be truncated. Trim the "Reading protocol" section to just the key file paths, and keep the Persona + Voice sections. The snapshot file carries the detailed context.

---

### vault-pull-inbox / sync

**"no inbox files found" — pull always empty**
Either no inbox files have been written from phone yet (expected if you haven't used the phone project), or the Drive folder ID in `drive-config.json` is wrong. Check:
```bash
cat $VAULT/.claude/drive-config.json
```
The `inbox_folder_id` field should match the `inbox/` folder inside your coach's Drive folder. If it's wrong, run `spawn-coach` again or update the file manually with the correct ID from Drive.

**Inbox file downloaded but content looks garbled or has extra backslashes**
Phone keyboards sometimes auto-escape markdown characters (asterisks, brackets). The `vault-pull-inbox` skill is designed to handle this — it strips common escaping artifacts before integrating. If a specific file is problematic, open it in the vault and clean it manually, then re-run the pull.

---

## What's next

After setup:
- Use the coach. The first 5-10 sessions are the most awkward; fluency comes with use.
- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand the system more deeply.
- See [docs/extending.md](docs/extending.md) to add custom skills or domain templates.
- Spawn additional coaches as you want them — `brain` then `spawn a cooking coach` etc.
