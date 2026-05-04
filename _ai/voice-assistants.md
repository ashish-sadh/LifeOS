# Voice Assistants (Siri / Google Assistant) — Surface Recipe

Bridge Siri/Google Assistant to LifeOS via iOS Shortcuts (or equivalent). Lets you trigger LifeOS actions hands-free.

**Status: recipe ready, gradual rollout recommended.**

## What this enables

- *"Hey Siri, log a pole session"* → opens Claude.ai pole project
- *"Hey Siri, what's on my list"* → reads tasks.md, speaks back
- *"Hey Siri, add 'review insurance' to my tasks"* → appends to tasks.md
- *"Hey Siri, who's birthday is coming up"* → reads People/, speaks
- *"Hey Siri, daily brief"* → reads today's brief from proposals/

## Pre-requisites

- iOS Shortcuts app
- Drive Desktop sync (so Shortcuts can read iCloud-mirrored files via Files app)
- Or: Drive iOS app (for direct Drive access)

## Pattern 1 — Open Claude project

Simplest. Just shortcuts to open Claude.ai with the right project pre-selected.

1. Shortcuts → New Shortcut → "Pole Coach"
2. Action: Open URL → `claude.ai/projects/<your-pole-coach-id>`
3. Add to Siri trigger phrase: "Pole coach"
4. Add to Home Screen icon

Now: *"Hey Siri, pole coach"* → Claude.ai opens with the right project.

## Pattern 2 — Read a vault file aloud

For status checks like "what's on my list".

1. Shortcuts → New Shortcut → "What's on my list"
2. Actions:
   - Get File from iCloud Drive: `LifeOS/Assistant/tasks.md`
   - Speak Text (the file contents)
3. Siri trigger: "What's on my list"

## Pattern 3 — Append to vault file

For *"Hey Siri, add to my tasks: review insurance"*.

1. Shortcuts → New Shortcut → "Add to tasks"
2. Actions:
   - Ask for Input (text) → "What to add?"
   - Get File from iCloud Drive: `LifeOS/Assistant/tasks.md`
   - Combine: existing content + "\n- [ ] " + provided input
   - Save File: overwrite `LifeOS/Assistant/tasks.md`
3. Siri trigger: "Add to my tasks"

## Pattern 4 — Trigger Mac action via SSH

For more complex operations (run a Claude Code session remotely).

1. Shortcuts → SSH to Mac → run command:
   `claude --print "..."`
2. Speak the response

Requires: SSH enabled on Mac, port forwarding or Tailscale for off-network access.

## Pattern 5 — Webhook to Mac daemon

If you set up OpenClaw or a custom HTTP server on Mac, Shortcuts can POST to it. The daemon does the heavy lifting; Shortcut just speaks the response.

Most flexible; requires the most setup.

## Recommended starter set

Build these 3 first:

1. **"Pole coach"** → opens Claude.ai project (Pattern 1, simplest)
2. **"What's on my list"** → reads tasks.md (Pattern 2)
3. **"Add to my tasks"** → appends to tasks.md (Pattern 3)

Total setup: ~30 min. Test for a week. Then build more if useful.

## Gotchas

- iOS Shortcuts can't directly write to Drive Desktop folders unless they're in iCloud Drive. Workarounds:
  - Use Drive iOS app + Drive integration in Shortcuts
  - OR: have Shortcuts write to iCloud, then Mac script syncs to Drive
- Siri responses are limited in complexity — keep prompts simple
- Voice mode on Claude.ai phone is often easier than Siri-Shortcut chains for substantive coaching
