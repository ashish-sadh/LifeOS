# Privacy model

Where your data lives, who can see it, and how to make the setup more private if needed.

---

## Data map

| Data | Where it lives | Who can access it |
|---|---|---|
| Vault files (profile, sessions, vocabulary, etc.) | Google Drive (and Mac local mirror if Drive Desktop) | You + anyone you share your Drive with |
| Context snapshots | Google Drive (`Coaches/<coach>/snapshots/`) | You + Claude.ai phone connector |
| Inbox files (phone captures) | Google Drive (`Coaches/<coach>/inbox/`) | You + Claude.ai phone connector |
| Conversation content | Anthropic servers (during API calls) | Anthropic processes it; not retained as memory |
| Shell scripts and config | Your Mac filesystem | Local only |
| `drive-config.json` (folder IDs) | `$VAULT/.claude/drive-config.json` — NOT in this git repo | You only (gitignored) |

**Short version**: your personal vault data is in your Google Drive. The framework code (this repo) contains no personal data. Anthropic processes your messages in real-time but does not store your vault content as memory.

---

## What Anthropic sees

Every message you send through Claude — via CLI, Claude.ai phone, or any surface — is processed by Anthropic's servers. This includes:
- The contents of any files Claude reads during a session (profile.md, vocabulary, sessions, etc.)
- Your messages and Claude's responses

Anthropic's data handling policies apply (see anthropic.com/privacy). The key point: Anthropic processes this content to generate responses; it does not retain your vault content as a persistent knowledge base. Each session starts fresh, reading from your Drive files.

**What this means**: your pole training history, cooking notes, and decision journal are in Google Drive, not in Anthropic's systems. If you stop using LifeOS, your data stays in your Drive unchanged.

---

## What Google sees

Your vault content is stored in Google Drive. Google's standard data handling applies:
- Google can see your Drive files (they're not encrypted at rest by Google by default)
- The Drive API connector authenticates with your Google account
- Drive Desktop mirrors your vault to your Mac filesystem

If you have concerns about Google's access to your personal data (coaching history, health observations, etc.), see "Making it more private" below.

---

## What the Drive connector grants

When you authenticate the Google Drive connector in Claude.ai, you grant it specific OAuth scopes. LifeOS uses:
- **Read**: required for phone Claude to read context snapshots
- **Create**: required for phone Claude to write inbox files
- **Update/Delete**: NOT required by default; only applies if you use Gemini (which has native Drive write access)

To review or revoke: Google Account → Security → Third-party apps with account access.

---

## What's in the git repo (vs. what's not)

**In this repo (public, on GitHub)**:
- Skills, templates, examples, scripts, docs
- No personal data of any kind
- Example files use sanitized placeholder data (`<your-name>`, `<your-gym>`, etc.)

**Not in this repo**:
- Your `$VAULT` directory (personal vault data lives in Drive, not in Git)
- `drive-config.json` (gitignored — contains your Drive folder IDs)
- Session logs, profile entries, vocabulary, snapshots — all gitignored
- API keys, tokens, credentials — all gitignored

The `.gitignore` in this repo explicitly excludes vault paths and personal config. Don't commit vault files; don't commit `drive-config.json`.

---

## Making it more private

### Option 1: Use a private/work Google account

If you don't want your coaching data mixed with your personal Gmail/Google Photos, create a separate Google account just for the vault. Drive storage is $3/month for 100 GB on a new account.

### Option 2: Encrypt the vault folder

If using Drive Desktop (vault on Mac filesystem), you can use macOS's built-in FileVault to encrypt your whole disk. This protects against physical device access; it doesn't affect Google's server-side access.

For stronger encryption: tools like Cryptomator can create an encrypted vault within your Drive, so files are encrypted before upload. This would require decrypting locally before Claude can read them, which adds friction to the workflow.

### Option 3: Local-only vault (no Drive)

Set `$VAULT` to a local directory (e.g., `~/Documents/Vault`) that is NOT in your Drive. All canonical files stay on your Mac. Phone access is not available (the Drive connector has nothing to read). This is the maximum-privacy option but gives up cross-device features entirely.

For cross-device on your own terms: self-hosted options like Nextcloud + a Nextcloud Drive connector would keep data on your own server, but require significantly more setup and aren't supported out of the box.

### Option 4: Use an open-source local model

If you have [OpenClaw](../_ai/openclaw.md) configured, you can route coaching sessions through a local model (Llama 3, Mistral, etc.) running entirely on your Mac. No data leaves your machine during the session. Capability trade-offs apply (local models are less capable than Claude), but for lightweight coaches (journaling, reflection, note synthesis) this is viable.

### Option 5: Selective sensitivity

Not all coaching data is equally sensitive. Consider:
- Running your thinking and journaling coaches through local-only or non-Anthropic surfaces
- Using cloud coaching only for less sensitive domains (cooking, speaking)
- Keeping `_shared/profile.md` minimal — it's read by every coach; put genuinely sensitive health or personal data only in domain-specific profile files that are read less frequently

---

## What's not a privacy risk here

- **The git repo**: no personal data. Forking or starring the repo reveals nothing about you.
- **The framework code**: scripts and skills are generic; they don't contain user data.
- **Context snapshots**: they contain compressed coaching history, but only what you explicitly told the coach. They don't mine your email, calendar, or files beyond what Claude read during sessions.

---

## Summary

The privacy model is: your data is in Google Drive (and optionally mirrored locally). Anthropic processes it during sessions but doesn't retain it. The framework code is public and contains nothing personal.

If Google or Anthropic having access to your coaching data concerns you, the most practical options are: separate Google account for the vault, or local-only vault without phone sync. Full local model routing is possible with OpenClaw but is a more involved setup.
