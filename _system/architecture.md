---
name: Coach System — Project Master Doc
description: Architectural decisions, roadmap, and operating principles for the multi-coach AI system built around this Obsidian vault. The single document a fresh Claude session should read to understand "what is this whole thing."
status: active
last_updated: 2026-05-03
type: project / system
tags: [project/coach-system, status/active, theme/personal-knowledge]
---

# Coach System

A personal "second brain + multi-coach" system. This is the master record — every architectural decision, every alternative considered, every reason for the choices made. Read this first when picking up the project.

---

## 1. The Vision

Multiple specialized AI coaches — one per life domain — that share a knowledge base and can be invoked from any device.

Active or planned coaches:
- **GetBetterAtPole** — pole dance training (active, first coach built)
- **GetBetterAtThinking** — clarity of thinking, decision-making, mental models
- **GetBetterAtFitness** — strength, mobility, conditioning outside pole
- **GetBetterAtSpeaking** — public speaking, communication
- **GetMoreOrganized** — life logistics, rituals, attention management

Each coach: own files (profile, program, vocabulary, sessions, context-snapshot) + reads shared infrastructure (`_shared/profile.md`, `_shared/principles.md`).

The vault also holds: daily notes, captured ideas, project notes, reading notes — a full second brain, not just coach files.

---

## 2. Architecture (final, evolved)

The system uses a **append-only message-bus architecture** built on the Google Drive connector. Mac canonical files live locally; Drive holds dated snapshots and inbox messages.

```
                    ┌─────────────────────────────────────┐
                    │         GOOGLE DRIVE                │
                    │    (relay / message bus, not sync)  │
                    │                                     │
                    │  Vault/                             │
                    │  ├── _shared/                       │
                    │  ├── pole/                          │
                    │  │   ├── snapshots/  ← Mac writes   │
                    │  │   ├── inbox/      ← Phone writes │
                    │  │   ├── days/       ← Mac writes   │
                    │  │   └── stable/                    │
                    │  ├── (other coaches same shape)     │
                    │  └── meta/                          │
                    └─────────┬─────────────────┬─────────┘
                              │                 │
                  read latest │                 │ create new
                  snapshot;   │                 │ inbox file
                  create      │                 │
                  inbox file  │                 │
                              │                 │
        ┌─────────────────────┴───┐   ┌─────────┴──────────────┐
        │  PHONE (Claude.ai)       │   │  MAC (Claude CLI)      │
        │                          │   │                        │
        │  Read: latest snapshot   │   │  Local canonical:      │
        │  Write: inbox/<dated>.md │   │  ~/Documents/Vault/    │
        │                          │   │                        │
        │  Conversation happens    │   │  vault-pull-inbox →    │
        │  Coach reads snapshot;   │   │   integrates phone     │
        │  responds in voice/text  │   │   updates              │
        │                          │   │                        │
        │  At end: create_file     │   │  Conversation happens  │
        │   in inbox folder        │   │                        │
        │                          │   │  vault-push-snapshot → │
        │                          │   │   uploads fresh dated  │
        │                          │   │   snapshot to Drive    │
        └──────────────────────────┘   └────────────────────────┘
```

**The key architectural insight**: The connector cannot UPDATE existing files — only CREATE new ones. So everything is append-only. Phone never overwrites; Mac never overwrites. New files are dated; latest-by-name wins. Drive accumulates files (markdown is tiny — non-issue for years).

**Why this is better than Drive Desktop**:
- No daemon running on Mac
- No always-on requirement
- Mac canonical files are local — fast, full power
- Privacy: only snapshots and inbox messages touch Drive, not your full vault
- Append-only = perfect history, no overwrite accidents
- Transparent failure: connector down → Mac still works locally; auto-syncs next online session

---

## 3. Why This Architecture (and what we rejected)

### Rejected: Cloudflare Tunnel + obsidian-web-mcp
- **What it would have been**: vault on Mac, MCP server on Mac exposed via Cloudflare Tunnel, phone connects to public URL
- **Why rejected**: required always-on Mac, ~1 hour setup, $4/mo Obsidian Sync, more moving parts, more privacy risk via tunnel
- **When to revisit**: if vault grows large enough that Drive's 15GB free tier is insufficient and we don't want to pay Drive Storage

### Rejected: OpenClaw + iMessage/Telegram bridge
- **What it would have been**: OpenClaw (open-source agent framework, Nov 2025) running on Mac, exposing the vault as messaging-app skills, phone interface via iMessage
- **Why rejected**: extra dependency, still requires always-on Mac, OpenClaw is new (more bugs), and the Drive-bridge architecture is simpler
- **When to revisit**: if phone friction is real after using current setup for 2+ weeks

### Rejected: Paste-back from phone via iOS Shortcut
- **What it would have been**: iOS Shortcut copies `context-snapshot.md` to clipboard → paste into Claude app → after conversation, paste markdown response back into Obsidian
- **Why rejected**: the user wanted seamless, and Drive connector eliminates the paste step entirely
- **When to revisit**: as a fallback if the Drive connector breaks

### Rejected: Pure Google Drive markdown (no Obsidian)
- **What it would have been**: vault is just markdown files in Drive, no Obsidian
- **Why rejected**: lose Obsidian's graph view, plugins, Smart Connections, daily notes integration — the *exact* features that justify Obsidian over a flat folder
- **When to revisit**: never — Obsidian's PKM features are the point

### Rejected: Two-vault separation (personal + AI workspace)
- **What it would have been**: one private vault (humans only, iCloud) and one AI workspace (Drive, Claude can read/write)
- **Why rejected**: over-engineered. Single vault simpler, conflicts manageable.
- **When to revisit**: if real-world conflicts become annoying

### Rejected: Notion / Mem.ai / Reflect / other AI-native PKM
- **What they would have been**: vendor-locked cloud PKM with built-in AI
- **Why rejected**: lose markdown portability, lock in to a vendor, lose Obsidian community + plugins, harder to migrate
- **When to revisit**: only if Obsidian itself shuts down (unlikely)

### Rejected: Migrating existing `~/workspace/GetBetterThinker`, `GetBetterSpeaker`, `GetMoreOrganized` folders
- **Why rejected**: build vault fresh; migrate per coach when each is engaged. Old folders may have stale assumptions worth dropping.
- **When to revisit**: when each coach gets built out — pull in any usable content selectively

---

## 4. Current Build State (as of 2026-05-03)

### ✅ Done
- Vault structure staged at `~/Documents/Vault/`
- Top-level `CLAUDE.md` (vault map + routing, meta-coach persona)
- `_shared/profile.md` (Asheesh: 34→35, climbing, on/off gym, right-side dominant, no hypermobility, right trap + left wrist + weak core)
- `_shared/principles.md` (10 coaching principles all coaches follow)
- `_shared/schedule.md` (stub — fills in via interview Q3)
- **GetBetterAtPole** coach fully scaffolded: CLAUDE.md, profile, program (Block 1: 4-week foundations), vocabulary (8 seed entries), sessions log (1 onboarding entry), context-snapshot
- 4 Agent Skills: `obsidian-sync`, `snapshot-regen`, `weekly-review`, `idea-distill`
- `Inbox.md` initialized
- Shell aliases (`pole`, `think`, `fit`, `speak`, `org`, `brain`) appended to `~/.zshrc`
- `SETUP.md` with manual setup checklist for the user
- Project plan archived at `~/.claude/plans/research-ways-to-make-concurrent-kay.md`

### 🔲 User-side manual setup pending (see Vault/SETUP.md)
- Install Google Drive for Desktop
- Move vault into Drive folder
- Update VAULT env var in zshrc
- Install Obsidian + community plugins (Smart Connections, Local REST API, Templater, Dataview)
- Install/configure mcp-obsidian for Claude Desktop
- Create Claude.ai "Pole Coach" project with system prompt referencing vault paths
- (Optional) iOS Shortcut for quick capture

### 🔲 Interview gaps to close in next pole session
- Q3: training cadence (classes/week, solo practice, conditioning capacity outside pole)
- Q4: 6-month wishlist moves (specific named goals)
- Q5: session rhythm (when/how user wants to interact with coach)
- What scares the user / what they avoid
- (Optional) body type / build, period regularity, bruising tendency

The pole coach's `CLAUDE.md` is instructed to surface these naturally during conversation, not grill the user with all gaps in one session.

---

## 5. Roadmap

### Phase 1 — Foundations (current)
Build pole coach end-to-end. Use it for 1-2 weeks. Fix friction. Refine `CLAUDE.md`, principles, skills based on real use.

### Phase 2 — Add second coach
Likely **GetBetterAtThinking** next (since the user has an existing `~/workspace/GetBetterThinker` folder). Same structure: CLAUDE.md, profile, program, vocabulary, sessions, snapshot. Pull selectively from old folder.

### Phase 3 — Add remaining coaches
Fitness, Speaking, Organized — one at a time, only when the user actually wants to engage that domain. Don't pre-build coaches that won't be used.

### Phase 4 — Cross-coach intelligence
Once 3+ coaches are active, the `brain` alias / weekly-review skill becomes powerful. Surface cross-domain patterns ("your pole shoulder mount is stuck because your pulling strength has dropped — your fitness coach hasn't seen you in 9 days").

### Phase 5 — System polish
- Custom skills that operate across the whole vault
- Vault audit scripts (find stale notes, broken links, unprocessed inbox)
- Possibly a Mac menubar app for capture (only if friction is real)
- Possibly migrate to Obsidian Sync ($4/mo) if Drive proves limiting

### Phase 6 — Optional advanced
- OpenClaw integration (only if phone friction becomes real)
- Custom MCP server for cross-coach reasoning
- Voice memo → vault automation pipeline

**The trap to avoid**: don't build Phase 4-6 before Phase 1 has been used for a few weeks. Real friction beats speculative friction.

---

## 6. Open Decisions / Gaps

| Decision | Status | When to revisit |
|---|---|---|
| Vault permanent location (Drive vs iCloud + Drive sync vs other) | Drive (chosen) | If Drive sync issues arise |
| iPhone Obsidian (skip vs add via Obsidian Sync) | Skipped | If phone-side typing becomes valuable |
| Whether to back up vault to private Git repo | Deferred | After 3+ coaches active |
| Tailscale vs Cloudflare for any future tunnel | N/A (no tunnel needed) | If Drive proves inadequate |
| Pole interview Q3-Q5 | Open | Next pole session |
| Performance/competition track for pole | Open | Once interview complete |

---

## 7. Operating Principles for the System Itself

These are meta-principles for *how the system evolves*, not for individual coaching.

### Principle 1: Use it before you optimize it
Don't add tooling, automation, or skills until real use surfaces real friction. "I'd find this useful someday" is not a build trigger.

### Principle 2: The vault is the memory; the system is just plumbing
Vault files are durable. Skills, aliases, MCP configs — replaceable. If anything breaks, the vault still works as plain markdown. Optimize for vault quality first; tooling second.

### Principle 3: Each coach earns its slot
Don't pre-build coaches for "future use." Build when there's a real domain you want to invest in for 3+ months. Empty coach folders are noise.

### Principle 4: Capture > distillation > synthesis
- **Capture** is easy: Inbox.md, voice notes, daily notes
- **Distillation** is the bottleneck: weekly the inbox should be processed
- **Synthesis** is the payoff: weekly reviews, cross-coach observations
Without distillation, the system clogs. Run `idea-distill` weekly.

### Principle 5: Honor the user's pacing
The user prefers: one question at a time during interviews, action over more meta-discussion when ready, conversational dialogue over structured forms. Match that.

### Principle 6: Don't summarize unprompted
At end of conversations, don't recap what was just said. The user can read. Get to the point and stop.

---

## 8. References

- **Plan file** (architectural decisions): `~/.claude/plans/research-ways-to-make-concurrent-kay.md`
- **SETUP file** (manual setup steps): `Vault/SETUP.md`
- **Top-level vault routing**: `Vault/CLAUDE.md`
- **Shared user facts**: `Vault/_shared/profile.md`
- **Shared coaching principles**: `Vault/_shared/principles.md`
- **Pole coach**: `Vault/Coaches/GetBetterAtPole/CLAUDE.md`
- **Skills**: `Vault/.claude/skills/{obsidian-sync,snapshot-regen,weekly-review,idea-distill}/SKILL.md`

External:
- Obsidian: https://obsidian.md
- Google Drive Desktop: https://www.google.com/drive/download/
- Claude Desktop: https://claude.ai/download
- mcp-obsidian: https://github.com/MarkusPfundstein/mcp-obsidian
- Anthropic Agent Skills: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview

---

## 9. How to keep building on this

When you (Asheesh) want to extend this system:

1. **Use it first.** Type `pole` and have a real coaching conversation. See what's missing.
2. **If the system itself needs improvement**: edit this file. Add a section under "Open Decisions" or "Roadmap." Future Claude sessions read this and can pick up.
3. **If a coach-specific change**: edit that coach's `CLAUDE.md` or skill files.
4. **If a new coach**: copy the `GetBetterAtPole/` folder structure, rewrite the persona, update profile/program for the new domain.

When a future Claude session opens at the vault root (`brain` alias):
- It reads top-level `CLAUDE.md` (vault map)
- It can read this file (`Projects/coach-system.md`) for system-level context
- It has all the principles, decisions, and roadmap right here

You can come back to this anytime, even months from now. The whole context is preserved.
