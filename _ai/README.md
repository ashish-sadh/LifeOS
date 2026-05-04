# _ai/ — Multi-Surface Setup Recipes

LifeOS is designed to work with any AI surface that can read markdown from your Drive. Each surface has different capabilities and a slightly different setup. Recipes live here.

## Surfaces (in order of use)

| Surface | File | Status |
|---|---|---|
| Claude Code CLI (Mac) | `claude-cli.md` | ✅ Active |
| Claude.ai (phone / web) | `claude-ai.md` | ✅ Active |
| Claude Desktop (Mac app) | `claude-desktop.md` | Optional, recipe ready |
| Google Gemini | `gemini.md` | Recipe ready, not yet tried |
| ChatGPT (Custom GPT) | `chatgpt.md` | Recipe ready, not yet tried |
| OpenClaw | `openclaw.md` | Recipe ready, defer install |
| Local LLM (Ollama) | `local-llm.md` | Recipe ready |
| Voice (Siri Shortcuts) | `voice-assistants.md` | Recipe ready |

## The bootstrap pattern

All surfaces use the same pattern:

1. Surface receives a SHORT system prompt: "You are my <role>. Read your full instructions from <file>."
2. The actual instructions live in a vault file (`CLAUDE.md` per coach, etc.)
3. Surface reads the file, follows its instructions

Benefits:
- Edit one file on Mac → all surfaces follow updates
- `coach-meta-review` skill can refine personas → all surfaces inherit
- Adding a new surface is just "tell it to read this file"

## Reading vault from each surface

| Surface | How it reads vault |
|---|---|
| Claude CLI | filesystem direct (Drive Desktop folder) |
| Claude.ai | Google Drive connector (file IDs or paths) |
| Gemini | `@Drive` native picker |
| ChatGPT | Custom GPT actions or Drive plugin |
| OpenClaw | Obsidian skill OR filesystem (with Drive Desktop) |
| Local LLM | Custom script reads filesystem |

## Adding a new surface

1. Read its native data-access mechanism (connector, plugin, etc.)
2. Authenticate (varies)
3. Write the system prompt — short bootstrap pointing at the right vault file
4. Test: ask "what's my pole status?" — verify it reads the vault correctly
5. Document quirks in `_ai/<surface>.md`
