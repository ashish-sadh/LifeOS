# Why Drive Desktop is recommended

Short version: it's free, takes 10 min to install, and removes ~80% of the complexity in the append-only architecture.

---

## What Drive Desktop is

Google's native macOS app that mirrors a folder on your Mac to your Google Drive cloud. Bidirectional sync, ~30 sec latency, runs as a low-footprint background process.

Distinct from:
- **Google Drive web** (drive.google.com) — just the website
- **Google Drive connector** (what Claude uses) — the API integration that lets Claude reach Drive content

Drive Desktop is a fourth thing: a filesystem mirror.

## Why install it

The framework works without Drive Desktop, but with Drive Desktop installed:

| Capability | Without | With Drive Desktop |
|---|---|---|
| Phone reads canonical files | ✅ via snapshot indirection | ✅ direct (or via snapshot — your choice) |
| Phone writes inbox files | ✅ create_file | ✅ same |
| Mac reads phone's inbox writes | ✅ connector + local cache | ✅ filesystem (faster) |
| Mac canonical files reach Drive | Snapshot pushes only | ✅ automatic, every file |
| Mac edits propagate to phone within seconds | Push delay | ✅ ~30 sec automatic |
| Mac can clean up old inbox files in Drive | ❌ manual web UI only | ✅ filesystem delete propagates |
| Mac can restructure (rename / move / delete) | Local-only; Drive stays stale | ✅ propagates to Drive |
| Drive accumulates files forever | ✅ until manual cleanup | ❌ Mac can clean up |
| Spawn new coach folders in Drive | ✅ via create_file | ✅ via filesystem |
| Snapshot regeneration required for phone | ✅ for fresh context | Optional (phone can read direct files) |

The blue line: Drive Desktop doesn't change what phone Claude can do (still create-only via connector). It changes what Mac can do — full filesystem operations now propagate to Drive.

## What it costs

- **Daemon footprint**: ~50 MB RAM, near-zero CPU at idle
- **Initial sync**: 5-10 min depending on your Drive size
- **Disk space**: Mirrors your Drive content locally (15 GB on free tier)
- **Privacy**: Same as before — your vault content is in Google's cloud either way (the connector reads/writes the same Drive)
- **Time to install**: 10 min

## Why I'd skip it (rare cases)

- **Work laptop with strict policies** — IT might block daemon installs
- **Disk space constrained** — full vault mirror takes some disk
- **Strong preference for explicit syncs** — some people want every Drive write to be intentional, not automatic

If any of these apply: stick with connector-only. The framework still works; you just live with append-only Drive accumulation and manual web cleanup.

## How to install

1. Download from https://www.google.com/drive/download/
2. Run the installer
3. Sign in with your Google account
4. Choose **Mirror files** mode (NOT Stream — Stream keeps files cloud-only and breaks Claude CLI's local file reads)
5. Wait for initial sync to complete

Verify it's working:
```bash
ls ~/Library/CloudStorage/
# Should show: GoogleDrive-<your-email>
```

## Migrating your vault into Drive Desktop

If you set up the framework before installing Drive Desktop:

```bash
# Move vault into Drive folder
mv ~/Documents/Vault ~/Library/CloudStorage/GoogleDrive-<your-email>/My\ Drive/

# Update VAULT env var in ~/.zshrc
# Find:    export VAULT="$HOME/Documents/Vault"
# Change:  export VAULT="$HOME/Library/CloudStorage/GoogleDrive-<email>/My Drive/Vault"

# Reload shell
source ~/.zshrc

# Verify
ls $VAULT
```

Drive Desktop will detect the moved folder and sync it to cloud. After sync, your phone Claude.ai can read/write the same files.

## What changes for the framework's skills

- `vault-pull-inbox` skill: still useful, but now reads files from local mirror (faster). Can also delete inbox files after processing (filesystem delete → propagates to Drive).
- `vault-push-snapshot`: less critical (phone can read canonical files directly), but still useful as a perf optimization (1 file vs many).
- `daily-consolidate`: same as before; can now delete the source inbox files after consolidating.
- `vault-maintain`: gains real cleanup capability — can archive old folders, split big files, delete stale snapshots.

The skill files in `skills/` describe behavior for both modes (with/without Drive Desktop). Mac CLI auto-detects which mode it's in by checking the VAULT path.

## TL;DR

Install Drive Desktop unless you have a specific reason not to. The cost is 10 minutes and ~50 MB RAM. The benefit is true bidirectional sync, real Drive cleanup, and dramatic simplification of the framework's runtime.
