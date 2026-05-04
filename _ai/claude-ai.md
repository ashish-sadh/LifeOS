# Claude.ai (phone / web) — Surface Recipe

How to set up Claude.ai (mobile app or web) as a surface for any LifeOS coach.

## Pre-requisites

- Claude.ai account
- Google Drive connector authenticated in Claude.ai (Settings → Integrations)
- The coach already exists in `LifeOS/GetBetterAt/<Coach>/`

## Setup per coach

For each coach you want phone access to:

### 1. Get the coach's CLAUDE.md file ID from Drive

In Mac CLI Claude session, run:
```
> what's the Drive file ID for LifeOS/GetBetterAt/Pole/CLAUDE.md
```

Or: open Drive web → navigate to the file → right-click → "Get link" → file ID is in the URL.

### 2. Create Claude.ai Project

1. Open Claude.ai (web or iOS)
2. New Project → name it (e.g., "Pole Coach")
3. Tap "Add instructions" (or "Custom instructions")
4. Paste the bootstrap system prompt below, replacing `<FILE_ID>` and `<COACH>`:

```
You are my <COACH> coach.

BEFORE responding to ANY message, you MUST use the Google Drive connector to read this file. It contains your full instructions, persona, and protocols:

  read_file_content with fileId: <FILE_ID>

That file is canonical. Follow it exactly. If you cannot read the file, tell me — don't fabricate.
```

5. Pin the project for one-tap access on phone

### 3. Test

In the project, ask: *"What's my <coach> status?"*

Expected: Claude says it's reading from Drive, then responds with your actual context (current state, recent sessions, etc.).

If Claude responds generically without referencing your data → the file ID is wrong, or Drive connector permissions are too narrow.

## How writes happen

Phone Claude can only **create** files via connector (no update/delete). The CLAUDE.md it reads instructs:

- For session captures, vocabulary additions, etc.: create a new file in `LifeOS/GetBetterAt/<Coach>/inbox/YYYY-MM-DDTHH-MM-<topic>.md`
- Mac will integrate these into canonical files at next `<coach>` session

Phone NEVER updates `profile.md`, `sessions.md`, `vocabulary.md` directly — that's Mac's job.

## Voice mode

Use Claude.ai voice mode for hands-free coaching during walks, post-class debriefs, etc. The bootstrap pattern works the same in voice mode — Claude reads the vault file, responds in voice.

## Updating the persona

Edit `CLAUDE.md` in the coach folder on Mac → Drive Desktop syncs → next phone session reads new persona automatically. No system prompt changes needed.

## Common issues

| Symptom | Fix |
|---|---|
| Claude doesn't read the file | Check Drive connector permissions; re-authenticate via Settings |
| Claude responds generically | File ID wrong, or Drive permissions don't grant read scope |
| File ID changed somehow | File IDs persist through edits; if changed, check if file was deleted/recreated. Get new ID. |
| Multiple Claude.ai projects | Each project has its own bootstrap pointing at its coach's CLAUDE.md |
