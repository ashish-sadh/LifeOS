# ChatGPT (Custom GPT) — Surface Recipe

ChatGPT has Drive integration via custom GPT actions or the official Drive connector. Useful as a fallback surface or for tasks where GPT-4 / GPT-4o specifically excels.

**Status: recipe ready, not yet personally tested.**

## Pre-requisites

- ChatGPT Plus or Team subscription (for Custom GPTs)
- Google Drive integration enabled in your ChatGPT account
- LifeOS vault at `My Drive/LifeOS/`

## Setup per coach

### 1. Create a Custom GPT

1. ChatGPT → Explore GPTs → "+ Create"
2. Name: "Pole Coach"
3. Instructions:

```
You are my pole dance coach.

BEFORE responding to ANY message, use the Google Drive integration to read:
  My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md

That file is your full persona, protocols, and instructions. Follow exactly.

When you produce information worth keeping (session log, vocabulary, profile updates):
- Create a new file at: My Drive/LifeOS/GetBetterAt/Pole/inbox/YYYY-MM-DDTHH-MM-<topic>.md
- Use the structured format described in the CLAUDE.md you just read

Don't summarize at end of every message.
```

4. Enable Knowledge: select the LifeOS folder via Google Drive integration (if available in your ChatGPT plan)

5. Configure capabilities: web browsing, code interpreter as needed

### 2. Test

Ask: *"What's my pole status?"*

Expected: GPT reads the vault file, responds with your specifics.

## Key difference from Claude

GPT-4 has slightly different reasoning style — sometimes more direct, sometimes less careful with tool-use sequencing. The CLAUDE.md was Claude-tuned; GPT may interpret slightly differently. Test how the coach feels.

## Trade-offs

| | Claude.ai phone | ChatGPT |
|---|---|---|
| Cost | $20/mo (Max) | $20/mo (Plus) |
| Phone voice | Native | Native |
| Drive integration | Connector | Plugin / GPT actions |
| Custom GPTs | Projects | Custom GPT |
| Reasoning style | Careful, long-form | More aggressive, sometimes faster |

## When to use ChatGPT over Claude

- You're already in the ChatGPT ecosystem
- Specific GPT-4 strengths you want (image gen via DALL-E, specific Custom GPTs)
- Resilience: a second AI surface in case Claude has issues

## Hybrid use

Multiple surfaces reading same vault is fine. Conflicts only if both write same file simultaneously (rare). Drive Desktop / Drive cloud handles via "kept versions."
