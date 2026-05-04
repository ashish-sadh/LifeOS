# OpenClaw — Surface Recipe

OpenClaw is an open-source personal AI assistant framework that runs on your Mac, bridges to messaging apps (iMessage, Telegram, WhatsApp, Discord), and has 5,700+ community skills. Adds an iMessage-native conversation surface for LifeOS.

**Status: recipe ready, defer install until phone friction is real (~3-4 weeks of use).**

## Why install eventually

| Capability | Without OpenClaw | With OpenClaw |
|---|---|---|
| iMessage / Telegram interface | ❌ | ✅ |
| Voice memos as primary capture | Awkward | ✅ Native |
| Proactive notifications (push) | ❌ | ✅ Scheduled |
| Multi-model fallback (Ollama for offline) | ❌ | ✅ |

## When NOT to install

- You haven't used current setup for 3+ weeks (don't pre-optimize)
- Claude.ai phone app feels good enough
- You don't want a Mac daemon running

## Pre-requisites (when ready)

- OpenClaw installed: https://openclaw.ai/
- Anthropic API key (or Claude Max subscription)
- Mac with iMessage configured (for the iMessage bridge)

## Setup

### 1. Install OpenClaw

```bash
brew install openclaw  # if available, OR clone from GitHub
openclaw init
```

### 2. Configure model

```yaml
# ~/.openclaw/config.yaml
model: claude-opus-4-7
api_key: <your Anthropic API key>
```

### 3. Install Obsidian skill

```bash
openclaw skill install obsidian
```

Configure to point at your vault:
```yaml
obsidian:
  vault_path: ~/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS
```

### 4. Configure coach personas

For each coach, add a routing rule:

```yaml
# ~/.openclaw/coaches/pole.yaml
trigger: "starts with 'pole:' OR comes in iMessage thread named 'pole-coach'"
system_prompt: |
  You are my pole dance coach. Read full instructions from:
  ~/Library/CloudStorage/.../LifeOS/GetBetterAt/Pole/CLAUDE.md
  Follow that file exactly.
skills: [obsidian, calendar, drive]
```

### 5. Configure messaging bridge

iMessage:
```bash
openclaw bridge imessage --enable
# requires Mac permissions for Messages.app
```

Or Telegram:
```bash
openclaw bridge telegram --bot-token <token>
```

### 6. Configure scheduled routines (optional)

```yaml
# ~/.openclaw/routines/morning-brief.yaml
schedule: "0 8 * * 1-5"  # weekdays 8am
action: "Read LifeOS/CLAUDE.md, then summarize: today's calendar, upcoming birthdays, active coach priorities. Send via iMessage to user."
```

### 7. Start daemon

```bash
openclaw start
# add to launchd for auto-start on login
```

## How LifeOS sees OpenClaw

OpenClaw becomes a **third surface** alongside Mac CLI and phone Claude.ai. It reads/writes the same vault files. Drive Desktop syncs everything across surfaces.

OpenClaw can:
- Update files in place (filesystem access — full CRUD)
- Trigger scheduled jobs that LifeOS skills define
- Bridge messages from iMessage/Telegram → coach response

## Coach interaction via iMessage

```
You: "pole: heading to class, what should I focus on?"
OpenClaw → reads Pole/CLAUDE.md + recent state
        → composes response
        → replies in iMessage thread

You: "pole: just got out, butterfly clicked on right left totally failed"
OpenClaw → notes session in sessions.md
        → updates context-snapshot.md
        → replies confirming log
```

Same vault as Mac CLI and Claude.ai. Edits propagate via filesystem (no inbox/snapshot indirection needed since OpenClaw has full access).

## Common issues

| Symptom | Fix |
|---|---|
| iMessage bridge fails | Grant Messages.app full disk access in System Settings → Privacy |
| Skills don't run | Check `openclaw status`; verify Obsidian skill points at correct vault path |
| Routines don't fire | Check `openclaw routines list`; verify daemon is running |
| API costs unexpected | Set rate limits in config; OpenClaw uses Claude API per call |

## Reverting

```bash
openclaw uninstall
```

LifeOS is unaffected — OpenClaw was a surface, not the source of truth.
