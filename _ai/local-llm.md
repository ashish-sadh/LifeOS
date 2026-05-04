# Local LLM (Ollama) — Surface Recipe

Run a local LLM (Llama, Mistral, etc.) via Ollama with filesystem access to the vault. Useful for offline coaching, privacy-sensitive sessions, or to reduce API costs.

**Status: recipe ready, not yet personally tested.**

## Pre-requisites

- Ollama installed: https://ollama.com/
- A capable model pulled: `ollama pull llama3.3` or similar (8GB+ recommended)
- Mac with enough RAM (16GB+ for medium models, 32GB+ for large)

## Setup

### 1. Install + pull model

```bash
brew install ollama
ollama pull llama3.3:70b  # adjust based on your hardware
ollama serve
```

### 2. Wrapper script for coach access

Create `~/bin/local-coach.sh`:

```bash
#!/bin/bash
# Usage: local-coach.sh pole "what's my status"

COACH=$1
shift
PROMPT="$@"

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
COACH_DIR="$LIFEOS/GetBetterAt/$(echo $COACH | sed 's/.*/\u&/')"

CLAUDE_MD=$(cat "$COACH_DIR/CLAUDE.md")
PROFILE=$(cat "$LIFEOS/_shared/profile.md")
COACH_PROFILE=$(cat "$COACH_DIR/profile.md")
VOCAB=$(cat "$COACH_DIR/vocabulary.md")
SESSIONS=$(tail -100 "$COACH_DIR/sessions.md")

ollama run llama3.3:70b "
You are my coach. Here are your instructions:
$CLAUDE_MD

User profile:
$PROFILE

Coach profile:
$COACH_PROFILE

Vocabulary:
$VOCAB

Recent sessions:
$SESSIONS

User question: $PROMPT
"
```

### 3. Add alias

In `~/.zshrc`:
```bash
alias lpole='~/bin/local-coach.sh pole'
alias lcook='~/bin/local-coach.sh cooking'
```

### 4. Test

```bash
lpole "what's my pole status"
```

## Trade-offs

| | Claude / Gemini cloud | Local Ollama |
|---|---|---|
| Quality | High (frontier models) | Lower (open-weight 70B is decent) |
| Speed | ~2 sec response | ~5-30 sec depending on hardware |
| Cost | API tokens | Hardware electricity |
| Privacy | Anthropic / Google sees data | Stays on your Mac |
| Offline | ❌ | ✅ |
| Tool use | Native | Limited (function calling support varies) |
| Voice | Native | Not built in (would need Whisper + TTS) |

## When to use local

- Offline work (camping, flights, no signal)
- Privacy-sensitive coaching (medical, financial)
- Cost reduction for high-frequency lookups
- Backup when Claude/Gemini are down

## Limitations

- Local 70B models aren't as careful as Claude Opus / GPT-4 / Gemini Pro
- The bootstrap pattern (read CLAUDE.md, follow exactly) requires good instruction-following — local models occasionally drift
- Tool use (skill invocation) is limited unless you use models tuned for it

For best results: use local LLM for **read-mostly** workflows (status checks, retrieval) and use Claude/Gemini for substantive coaching.

## Future direction

When local models reach Claude-quality (likely within 1-2 years), shift more workflows local. The vault doesn't care which model reads it.
