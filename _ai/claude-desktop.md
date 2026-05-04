# Claude Desktop — Surface Recipe

Claude Desktop (the Anthropic macOS/Windows app) with the **mcp-obsidian** MCP server gives you a GUI surface with direct vault read/write — no terminal required. Good fit for users who prefer a conversational GUI to the CLI, or who use Windows where Claude Code CLI isn't available.

**Status: recipe ready; MCP tool IDs may vary across mcp-obsidian versions.**

## How it compares to other surfaces

| Capability | Claude Code CLI | Claude Desktop + mcp-obsidian | Claude.ai phone |
|---|---|---|---|
| Vault read | Full filesystem | Via MCP (Obsidian vault tools) | Via Drive connector |
| Vault write | Full filesystem | Via MCP (Obsidian vault tools) | Create-only via Drive connector |
| CLAUDE.md auto-load | Yes (from folder) | No (manual project system prompt) | No (manual system prompt) |
| Agent Skills auto-load | Yes | No | No |
| Scheduled jobs | Yes (launchd) | No | No |
| Platform | Mac only | Mac + Windows | Any |
| Terminal needed | Yes | No | No |

Bottom line: Claude Desktop is a clean GUI experience for conversations and vault updates, but lacks the skill auto-invocation and CLAUDE.md auto-loading that make the CLI so powerful. Use it for lightweight sessions; use CLI for heavy coaching and syncing.

## Pre-requisites

- Claude Desktop installed (download from anthropic.com)
- Node.js installed (`node --version` works)
- LifeOS vault on disk (Drive Desktop recommended; or local `~/Documents/Vault`)
- `$VAULT` env var set in `~/.zshrc` (set by bootstrap.sh)

## Setup

### 1. Install mcp-obsidian

```bash
npm install -g mcp-obsidian
```

Verify:
```bash
mcp-obsidian --version
```

If `mcp-obsidian` isn't found after install, try `npx mcp-obsidian` (npx variant in the config below).

### 2. Configure Claude Desktop

Open (or create) the config file:

```bash
open ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

On Windows: `%APPDATA%\Claude\claude_desktop_config.json`

Add the MCP server entry. Replace `YOUR_VAULT_PATH` with your actual vault path (e.g., `/Users/you/Library/CloudStorage/GoogleDrive-you@gmail.com/My Drive/Vault`):

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "mcp-obsidian",
      "args": ["YOUR_VAULT_PATH"]
    }
  }
}
```

If `mcp-obsidian` isn't globally on PATH, use the npx form:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": ["-y", "mcp-obsidian", "YOUR_VAULT_PATH"]
    }
  }
}
```

To find your vault path:
```bash
echo $VAULT
```

### 3. Restart Claude Desktop

Quit and reopen Claude Desktop. The Obsidian MCP server should show up in the tool list (look for the MCP icon in the chat).

### 4. Create a Project per coach

Claude Desktop supports Projects (similar to Claude.ai). Create one per coach:

1. Open Claude Desktop → New Project → name it (e.g., "Pole Coach")
2. Add system prompt — paste the coach's bootstrap prompt:

```
You are my pole dance coach.

At the start of every conversation:
1. Use the obsidian MCP tools to read: Coaches/GetBetterAtPole/CLAUDE.md
   That file has your persona and full protocols. Follow it.
2. Also read: Coaches/GetBetterAtPole/context-snapshot.md
   That file has your current context.

When the conversation produces updates (session log, vocabulary, profile notes):
- Use obsidian MCP tools to append to the appropriate files
- For session entries: append to Coaches/GetBetterAtPole/sessions.md
- For vocabulary: append to Coaches/GetBetterAtPole/vocabulary.md
- For profile notes: append timestamped entry to Coaches/GetBetterAtPole/profile.md

Read files before responding to any substantive question. Don't fabricate context.
```

Adjust the path (`GetBetterAtPole`) to match your actual coach name.

## What mcp-obsidian provides

Common tools (exact names vary by version — check the tool list in Claude Desktop):

| Tool | What it does |
|---|---|
| `obsidian_read_note` | Read a vault file by path |
| `obsidian_write_note` | Write or overwrite a vault file |
| `obsidian_append_to_note` | Append text to an existing file |
| `obsidian_create_note` | Create a new file |
| `obsidian_search` | Full-text search across the vault |
| `obsidian_list_files` | List files in a folder |

Unlike the Drive connector, mcp-obsidian can **update** and **overwrite** existing files — not just create. This is the same capability Claude Code CLI has via its filesystem tools.

## Limitations

- **No CLAUDE.md auto-load**: CLAUDE.md is not auto-detected from a folder. The project system prompt must explicitly instruct Claude to read it.
- **No skills auto-invocation**: Skills in `.claude/skills/` are not discovered. The project system prompt can include skill-like instructions manually, but they don't auto-trigger.
- **No scheduled jobs**: Background automation (daily consolidate, weekly review) doesn't run through Claude Desktop. Those still require the CLI.
- **Drive sync**: mcp-obsidian reads/writes files on disk. If using Drive Desktop (recommended), changes propagate to Drive automatically. Without Drive Desktop, updates don't reach phone.

## Common issues

| Symptom | Fix |
|---|---|
| MCP server doesn't appear in tool list | Restart Claude Desktop; check config JSON syntax (no trailing commas) |
| `mcp-obsidian: command not found` | Use the `npx` form in config; or `npm install -g mcp-obsidian` and verify `which mcp-obsidian` |
| Vault path error | Run `echo $VAULT` in terminal; paste exact output into config (no trailing slash) |
| Claude reads wrong files | Path in system prompt must be relative to vault root, not absolute (e.g., `Coaches/GetBetterAtPole/CLAUDE.md`, not the full path) |
| File writes not propagating to phone | Check Drive Desktop sync status; if not installed, writes stay local |

## Why use this over Claude Code CLI

- **Windows users**: CLI only supports Mac. Desktop + mcp-obsidian works on Windows.
- **Non-technical users**: no terminal comfort needed. GUI-native workflow.
- **Occasional use**: easier to open for a quick session than to open a terminal and run an alias.

For power users on Mac who run the CLI daily, Claude Desktop adds little — the CLI has all the same vault access plus auto-loading and skills. But as a backup surface or for team members who don't use terminals, it's a solid option.
