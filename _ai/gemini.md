# Google Gemini — Surface Recipe

Gemini has native Drive integration (via `@Drive`) with full read/write/update/delete capabilities — meaningfully stronger than Claude.ai's Drive connector. Good fit for coaches that benefit from Workspace integration (Gmail, Calendar, Docs).

**Status: recipe ready, not yet personally tested.**

## Pre-requisites

- Google account (you're already in the ecosystem)
- Gemini access (gemini.google.com or Android/iOS app)
- LifeOS vault at `My Drive/LifeOS/`

## Setup per coach (Gemini Gem)

### 1. Create a Gem

1. Open gemini.google.com
2. Tap "Gems" → "New Gem"
3. Name: e.g., "Pole Coach"
4. **Instructions** (system prompt):

```
You are my pole dance coach.

BEFORE responding to ANY message, use @Drive to find and read this file:

  My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md

That file contains your full instructions, persona, and protocols.
Follow it exactly. If you cannot read the file, tell me — don't fabricate.

When the conversation produces information worth keeping (session log, new vocabulary, profile observations):
- For session logs and inbox-style captures: create a new file at `My Drive/LifeOS/GetBetterAt/Pole/inbox/YYYY-MM-DDTHH-MM-<topic>.md`
- For direct updates to profile.md, vocabulary.md, etc.: edit them in place (you have full Drive write access, unlike Claude's connector)

Don't summarize at end of every message. Match my pace.
```

5. (Optional) Attach the Pole/ folder via @Drive in knowledge

### 2. Test

Ask: *"What's my pole status?"*

Expected: Gemini opens the file via @Drive, reads, responds with your context.

## Key difference from Claude.ai

Gemini can **update** existing files (Claude's connector cannot). So Gemini doesn't need the inbox-pattern indirection — it can edit `sessions.md` directly. The CLAUDE.md instructs both modes; Gemini uses the direct-update path.

This means: faster integration, no Mac processing of inbox files needed for Gemini-driven changes.

## Trade-offs vs. Claude.ai

| | Claude.ai phone | Gemini |
|---|---|---|
| Reasoning style | More careful, longer-form | Faster, more concise |
| Voice mode | ✅ | ✅ native |
| Drive operations | Read + create only | Full CRUD |
| Workspace (Gmail/Calendar/Docs) | Separate connectors | All integrated |
| Cost | Claude Max sub | Free tier generous |

## When to use Gemini over Claude.ai

- Quick lookups during the day (Gemini is faster)
- Tasks involving Gmail/Calendar/Docs
- When Claude.ai is sluggish or hits rate limits
- For specific coaches where Gemini's style fits

## When to keep Claude.ai

- Long-form reasoning sessions
- Coaches where you've tuned the persona for Claude
- Voice mode for hands-free with rich context
- Complex tool-use chains

## Both at once

You can have both Gemini AND Claude.ai pointing at the same coach. They share the vault. Differences in style become a feature — pick the surface that fits your moment.
