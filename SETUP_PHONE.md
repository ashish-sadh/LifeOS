# Phone & AI Surface Setup

Paste-ready instructions for configuring each AI surface to work with your LifeOS vault. Do these once per surface.

The key idea: **each AI surface gets a short bootstrap prompt that points at your coach's `CLAUDE.md` file in Drive.** That file has all the real instructions. When you update the file on Mac, every surface picks up the new persona automatically.

---

## Your Drive folder/file IDs (from `.claude/drive-config.json`)

| Resource | ID |
|---|---|
| **LifeOS root folder** | `16R7Im7U03s-7HcNVPOL1hJRVUZ9RQuV1` |
| **Pole coach folder** | `19jBEGKmUshHlq0ua_yLKKhUbXyc1JvIV` |
| **Pole CLAUDE.md (bootstrap file)** | `1w-hCPfmu2xesAW-zPQmh2ynSrNRUjiT5` |
| **Pole inbox folder** (where phone writes captures) | `1MQDdCu_4ELqPBD8RlE7HAIYbAVqdykBo` |
| **Pole snapshots folder** | `1b81antYO8my769n4BdXZCeO6HYewToNs` |

You'll paste these into system prompts below.

---

## 1. Claude.ai (phone + web) — Pole Coach

**One-time setup, ~3 min.**

### Steps

1. Open **Claude.ai** (iOS app or web)
2. Verify Google Drive connector is enabled: **Settings → Connectors → Google Drive** — should show "Connected"
3. **Create new Project**:
   - Name: `Pole Coach`
   - (optional description: "My pole dance coach. Reads vault from Drive.")
4. Tap **"Add instructions"** (or "Custom instructions" depending on app version)
5. Paste this exactly:

```
You are my pole dance coach.

BEFORE responding to ANY message, you MUST use the Google Drive connector to read this file. It contains your full instructions, persona, and protocols:

  read_file_content with fileId: 1w-hCPfmu2xesAW-zPQmh2ynSrNRUjiT5

That file is canonical — follow it exactly.

If you cannot read the file (insufficient permissions, etc.), tell me and stop. Do not fabricate.

When the conversation produces information worth keeping (session log, vocabulary additions, profile observations):
- Use create_file to write a new inbox file:
  parentId: 1MQDdCu_4ELqPBD8RlE7HAIYbAVqdykBo
  title: YYYY-MM-DDTHH-MM-<topic>.md (use current local time)
  contentMimeType: text/markdown
  disableConversionToGoogleType: true
  textContent: structured per the format in CLAUDE.md you just read

The connector cannot UPDATE existing files — only CREATE new ones. The inbox folder is append-only. My Mac will integrate these into canonical files when I run `pole`.

Don't summarize at end of every message. Match my pace.
```

6. **Save** the project
7. **Pin** it (long-press → Pin, or pin icon)
8. **Test**: open project, ask *"What's my pole status?"*

Expected: Claude says it's reading from Drive, then references your specifics (right trap, shoulder mount progression, butterfly, etc.).

If it gives generic advice without your context → file ID wrong, or Drive connector permissions too narrow. Re-run `/mcp` in Claude Code on Mac to refresh the connector if needed.

---

## 2. Google Gemini — Pole Coach Gem (optional, gives you a second surface)

**One-time setup, ~3 min.**

### Steps

1. Open **gemini.google.com**
2. Click **Gems** → **New Gem**
3. **Name**: `Pole Coach`
4. **Instructions**:

```
You are my pole dance coach.

BEFORE responding to ANY message, use @Drive to read this file (it contains your full instructions):

  My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md

That file is canonical — follow it exactly.

When the conversation produces information worth keeping (session log, vocabulary additions, profile observations):
- Option A (preferred since you have full Drive access): UPDATE the appropriate canonical file directly:
  - Session log → append to My Drive/LifeOS/GetBetterAt/Pole/sessions.md
  - New vocabulary → add or update entry in My Drive/LifeOS/GetBetterAt/Pole/vocabulary.md
  - Profile observation → append timestamped note to My Drive/LifeOS/GetBetterAt/Pole/profile.md
- Option B (fallback): create a new file in My Drive/LifeOS/GetBetterAt/Pole/inbox/ with timestamp filename. My Mac will integrate it.

Use Option A whenever possible since you have native Drive write access (unlike Claude.ai's create-only connector).

Don't summarize at end of every message. Match my pace.
```

5. (Optional) **Knowledge**: attach the `LifeOS/GetBetterAt/Pole/` folder via @Drive
6. **Save** Gem
7. **Test**: ask *"What's my pole status?"*

### When to use Gemini vs. Claude.ai
- **Gemini**: faster responses, native Workspace (Gmail/Calendar/Docs) integration, can update Drive files directly
- **Claude.ai**: more careful long-form reasoning, voice mode, the persona was originally tuned for Claude

Both can coexist. Vault is the same source of truth.

---

## 3. ChatGPT (Custom GPT) — Pole Coach (optional, third surface)

**Requires ChatGPT Plus. Setup ~5 min.**

### Steps

1. **ChatGPT** → **Explore GPTs** → **+ Create**
2. **Name**: `Pole Coach`
3. **Instructions**:

```
You are my pole dance coach.

BEFORE responding to ANY message, use the Google Drive connector to read this file:

  My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md

That file is canonical — follow it exactly.

When you produce information worth keeping (session log, vocabulary additions, profile observations):
- Create a new file at: My Drive/LifeOS/GetBetterAt/Pole/inbox/YYYY-MM-DDTHH-MM-<topic>.md
- Use the structured format described in CLAUDE.md

Don't summarize at end of every message. Match my pace.
```

4. **Knowledge**: enable Google Drive integration (in the GPT builder), point at the LifeOS folder if available
5. **Capabilities**: enable web browsing (useful for coach research)
6. **Save** GPT
7. **Test**: *"What's my pole status?"*

---

## 4. Voice via Siri Shortcuts (optional, hands-free)

**Setup ~10 min.**

### "Pole Coach" Shortcut

1. **iOS Shortcuts** app → **+ New Shortcut**
2. Name: `Pole Coach`
3. Action: **Open URL**
   - URL: `https://claude.ai/project/<your-pole-coach-project-id>` (get from Claude.ai web; it's in the URL when you open the project)
4. Add to Home Screen
5. Add Siri trigger phrase: *"Pole coach"*

Now: *"Hey Siri, pole coach"* → Claude.ai opens to the pinned project, ready for voice mode.

### "What's on my list" Shortcut

1. New Shortcut → "What's on my list"
2. Action: **Get File from Google Drive**
   - Path: `LifeOS/Assistant/tasks.md`
3. Action: **Speak Text** (the file content)
4. Siri trigger: *"What's on my list"*

---

## 5. OpenClaw — iMessage interface to your coaches (optional, defer)

Recommend deferring until you've used Claude.ai phone for ~3 weeks and decided the friction is real.

When ready, see `_ai/openclaw.md` for full setup recipe. Summary:
- Install OpenClaw on Mac
- Configure with Anthropic API key
- Install Obsidian skill, point at `LifeOS/`
- Configure coach personas with bootstrap prompts (similar to above)
- Configure iMessage bridge
- Now: text "pole: heading to class" → coach responds in iMessage

---

## When to set up each surface

**Always set up Claude.ai phone.** That's your primary mobile coaching interface.

Add others when you have a specific need:
- **Gemini** if you want full Drive write access from phone (no inbox indirection) or Workspace integration
- **ChatGPT** if you're already in that ecosystem or want resilience
- **Voice** when you'd actually use hands-free triggers (during walks, post-class)
- **OpenClaw** when iMessage interface adds value over Claude.ai

Setup is incremental. Don't pre-configure surfaces you won't use.

---

## Updating coach personas

After initial setup, you NEVER need to touch the system prompts again. To refine a coach's behavior:

1. On Mac, type the coach alias (e.g., `pole`)
2. Edit the persona via conversation: *"update my CLAUDE.md to be more direct, less encouraging"*
3. Coach updates `My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md`
4. Drive Desktop syncs to cloud
5. Next phone session: phone Claude reads the updated file via the same bootstrap prompt
6. Persona is updated everywhere

This is the value of the bootstrap pattern.

---

## When file IDs change

If you delete and re-create a coach, file IDs change. Then you'd need to:

1. Look up the new ID: search Drive web for `CLAUDE.md` in the coach folder, copy file ID from URL
2. Update the system prompt in your Claude.ai project (replace the old ID with the new one)

Folder IDs persist through Drive renames; file IDs sometimes don't. The skills in this repo handle this for you when spawning new coaches.

---

## Multi-coach phone setup

When you spawn a new coach (`brain` → "spawn a cooking coach"):

1. The `spawn-coach` skill outputs a phone Claude.ai system prompt with the new coach's file IDs filled in
2. Copy that prompt
3. Create a new Claude.ai Project named "Cooking Coach"
4. Paste the prompt
5. Pin it

Repeat per coach. Each lives as its own pinned project.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Claude says "insufficient permissions" reading file | Re-authenticate Google Drive connector in Claude.ai Settings |
| Claude responds generically | File ID wrong, or persona file is empty/malformed. Verify `My Drive/LifeOS/GetBetterAt/Pole/CLAUDE.md` exists and has content |
| Phone writes don't appear on Mac | Check Drive Desktop sync status on Mac. Force pause/resume if stuck |
| "fileId not found" | The file was deleted and re-created (different ID). Update system prompt with new ID |
| Multiple Claude.ai projects all named "Pole Coach" | Delete duplicates, keep one |
