---
name: spawn-coach
description: End-to-end creation of a new coach. Asks for domain and name, scaffolds local files from domain template, creates Drive folders, adds shell alias, runs onboarding interview, generates initial snapshot, outputs system prompt for phone Claude.ai project. Triggers on "spawn coach" / "create [domain] coach" / "add a [domain] coach".
---

# Skill: spawn-coach

Creates a new coach in 10 minutes. Handles every step from "I want a cooking coach" to "Pole Coach project ready on phone."

## When to invoke

- User: "spawn a [domain] coach" / "I want a coach for X" / "add a [domain] coach"
- Should typically be invoked from vault root (via `brain` alias), not from within an existing coach
- Confirms before doing anything (creating files, modifying zshrc)

## What it does

End-to-end:

1. **Confirm domain and name**
   - Domain: cooking / thinking / fitness / pole / speaking / writing / [other]
   - Coach name: defaults to `GetBetterAt<DomainCapitalized>` or asks for override
   - Shell alias: defaults to short form (`cook`, `pole`, `think`) or asks

2. **Pick a template**
   - If `examples/<domain>/` exists in framework, copy it as starting point
   - Otherwise, use the generic `templates/coach-template/` and customize
   - User can override: "use the cooking template but call it 'kitchen' instead"

3. **Run onboarding interview** (5-10 min)
   - Asks domain-relevant questions in rounds (one at a time)
   - Common rounds:
     - Round 1: Where are you with this domain? Beginner / intermediate / advanced?
     - Round 2: Recent history? What's working / what's stuck?
     - Round 3: Body / context (for physical) or constraints (for cognitive)
     - Round 4: 6-month goals?
     - Round 5: How do you want to interact?
   - Different domains have different round content (see "Domain templates" below)

4. **Populate files** based on interview
   - `Coaches/GetBetterAt<Name>/profile.md` — domain-specific user state
   - `Coaches/GetBetterAt<Name>/program.md` — initial program (provisional, refined later)
   - `Coaches/GetBetterAt<Name>/vocabulary.md` (or domain equivalent) — seeded with domain basics
   - `Coaches/GetBetterAt<Name>/sessions.md` — onboarding entry
   - `Coaches/GetBetterAt<Name>/CLAUDE.md` — coach persona for the domain
   - `Coaches/GetBetterAt<Name>/context-snapshot.md` — initial digest

5. **Create Drive folders**
   - `Vault/<coach-shortname>/snapshots/`
   - `Vault/<coach-shortname>/inbox/`
   - `Vault/<coach-shortname>/days/`
   - **Update `Vault/.claude/drive-config.json` with new folder IDs.** Resolve them via Drive `search_files` after the desktop sync uploads the new folders (usually <30s). If the file does not exist yet, create it with this schema:
     ```json
     {
       "version": 1,
       "vault_root_id": "<root>",
       "coaches": {
         "<shortname>": {
           "local_path": "GetBetterAt/<Name>",
           "inbox_id": "<id>",
           "snapshots_id": "<id>"
         }
       }
     }
     ```
     This file is **load-bearing** — without it, `vault-pull-inbox` cannot run and phone→Mac sync silently breaks. Don't skip it.

6. **Push initial snapshot to Drive**
   - Use `vault-push-snapshot` skill

7. **Add shell alias**
   - Append to `~/.zshrc`:
     ```bash
     alias <shortname>='cd "$VAULT/Coaches/GetBetterAt<Name>" && claude --dangerously-skip-permissions'
     ```

8. **Output system prompt for Claude.ai phone project**
   - Generate the complete system prompt with the new coach's Drive folder IDs
   - Show to user with copy-paste-ready instructions

9. **Final summary**
   ```
   ✅ Coach spawned: GetBetterAtCooking

   Local files:    ~/Documents/Vault/Coaches/GetBetterAtCooking/
   Drive folders:  https://drive.google.com/drive/folders/<id>
   Shell alias:    cook (open new terminal tab to load)
   Phone setup:    [system prompt copy-pasted above]

   Next: type `cook` in new terminal to start your first real session.
   The pole coach interview gaps (e.g., training cadence) will surface
   naturally as you converse.
   ```

## Domain templates

Different domains shape the coach differently. The skill checks `examples/<domain>/` first; if missing, picks the closest analog:

| Domain | Distinctive structure | Closest analog if no template |
|---|---|---|
| Pole / Aerial | `progressions/`, `vocabulary.md` (moves) | examples/pole |
| Fitness | `progressions/`, `metrics/` | examples/pole |
| Cooking | `recipes/`, `techniques/`, `ingredients/` | examples/cooking |
| Thinking | `decisions/`, `models/`, `journal/`, `predictions/` | examples/thinking |
| Speaking | `talks/`, `feedback/`, `themes/` | examples/speaking |
| Writing | `pieces/`, `voice.md`, `feedback/` | examples/cooking (creative) |
| Organization | `routines/`, `systems/`, `metrics/` | examples/thinking |

When using the generic `templates/coach-template/`, the skill prompts:

> *"What's distinctive about how knowledge accumulates in [domain]? Should we have any of these folders: progressions, recipes, decisions, journal, themes, routines? Or something else?"*

## Onboarding interview pattern

The skill conducts the interview as the coach itself, not as the meta-skill. Once the coach files exist (after Round 1), the coach reads them and continues the interview "in character."

Round structure example (cooking):

**Round 1 — current state**
- "Where are you with cooking? Beginner / intermediate / advanced? Anything specific to recent stage?"
- "What got you into cooking? What's your why?"
- "Specific failure mode you're trying to fix?"

**Round 2 — kitchen + tools**
- "Tell me your kitchen: gas/electric, what you have, what's missing."
- "Knife situation. Cookware essentials."
- "Pantry — what's always stocked?"

**Round 3 — patterns**
- "What do you cook most weeks?"
- "What do you avoid? Why?"
- "Diet constraints (medical, ethical, preference)?"

**Round 4 — goals**
- "Specific dishes you want to nail in 6 months?"
- "Skills you want to develop (knife, sourdough, sauces, plating, fermenting)?"
- "Anything performative (hosting, gifting, photography)?"

**Round 5 — interaction style**
- "When do you want to chat with the coach? Pre-cook brief / post-cook log / mid-cook help / weekly planning?"
- "Voice on phone or text?"

Domain-specific rounds below. Use the most relevant domain as the starting point, then adapt.

---

**Pole / Aerial**

*Round 1 — current state*
- "Where are you in aerial? Beginner / intermediate / advanced? Months or years in?"
- "What apparatus? Pole static / spin / lyra / silks / something else?"
- "Specific moves you're working now, and what's next?"

*Round 2 — body*
- "Any injuries — healed, active, or chronic? Anything that limits training?"
- "Asymmetries: stronger side, weaker grip, hip that doesn't open as much?"
- "Fear or avoidance list — moves you're not ready to try or have stalled on?"

*Round 3 — training setup*
- "How often do you train? Studio vs home rig?"
- "Do you have a teacher or class structure, or are you self-directed?"
- "How do you currently log training? (Most people say 'I don't') "

*Round 4 — goals*
- "6-month goal: specific move, routine, strength benchmark?"
- "Performance or competition aspirations? Or purely personal?"

*Round 5 — interaction style*
- "When do you want to use this coach? Post-training log / pre-class brief / injury check-in / program planning?"

---

**Fitness**

*Round 1 — current state*
- "What are you training now? Lifting, running, mobility, sport-specific, general fitness?"
- "Experience level: years lifting, any prior programs, how consistent?"
- "What does a normal training week look like?"

*Round 2 — equipment + access*
- "Home gym, commercial gym, or both?"
- "Key equipment available (rack, cables, machines, barbells)?"
- "Any equipment you lack that limits you?"

*Round 3 — body + injury*
- "Past injuries — healed but worth knowing about. Anything active?"
- "Recovery patterns: sleep quality, how you typically feel 48h after a hard session?"
- "Any movement restrictions (can't squat deep, shoulder impingement, etc.)?"

*Round 4 — goals*
- "Primary goal: strength, hypertrophy, body composition, longevity, sport?"
- "6-month concrete target: specific lift numbers, body weight, performance test?"
- "What's blocked you from hitting this before?"

*Round 5 — interaction style*
- "Pre-session brief / post-session log / weekly planning / injury check-in?"

---

**Thinking**

*Round 1 — decision landscape*
- "What kinds of decisions do you most want to get better at? (Career, investing, interpersonal, product/strategy, day-to-day?)"
- "How frequently are you facing hard decisions — ongoing or currently facing a specific one?"

*Round 2 — current system*
- "How do you currently think through decisions? Journal, spreadsheet, whiteboard, just in your head?"
- "Do you track past decisions and outcomes? Or do you lose visibility once a decision is made?"

*Round 3 — recent cases*
- "Tell me about a decision you got right and one you regret. What made the difference?"
- "What's your most common failure mode — going too fast, overthinking, missing key info, listening to the wrong people?"

*Round 4 — mental models*
- "Any frameworks you already use — inversion, base rates, pre-mortem, something else?"
- "What mental model do you want to get better at?"

*Round 5 — interaction style*
- "Do you want to talk through decisions in real time, or debrief after you've made them?"
- "How much do you want the coach to push back vs. help you sharpen your own thinking?"

---

**Speaking**

*Round 1 — current state*
- "What context do you speak in? Internal (team, company), external (conference, client), academic, sales, something else?"
- "Frequency: how many talks or presentations in the last 6 months?"
- "What's your baseline — anxious / comfortable / depends on audience?"

*Round 2 — failure modes*
- "Specific recurring problem you want to fix. Rushing, filler words, losing the thread, energy, structure, nerves?"
- "What feedback have you gotten — from audiences, managers, coaches?"

*Round 3 — upcoming talks*
- "Anything coming up in the next 2 months? Topic, audience size, stakes?"
- "Do you script, outline, or speak from memory?"

*Round 4 — goals*
- "6-month target: specific talk type, specific audience, or a behavior you want eliminated?"
- "What would a 'good talk' feel like for you — internal feeling vs. external response?"

*Round 5 — interaction style*
- "Pre-talk prep / post-talk debrief / watching recordings together / workshop mode?"

---

**Writing**

*Round 1 — what you write*
- "Form: essays, fiction, poetry, non-fiction, hybrid, something else?"
- "Who are you writing for? Yourself, literary readers, professional context, no audience yet?"
- "Frequency: do you write regularly or in bursts?"

*Round 2 — history*
- "Years of writing and rough volume. Anything published, shared, or submitted?"
- "The piece you've abandoned most often — what's the pattern?"
- "A piece you're proud of — what worked in it?"

*Round 3 — current work*
- "What are you working on now? What's stuck?"
- "Where do you get stuck most: starting, developing, finishing, revising?"

*Round 4 — voice and feedback*
- "How do you take external feedback — receptive, defensive, or depends on the source?"
- "Publication goal active, building toward, or writing for self?"

*Round 5 — interaction style*
- "Mid-draft help / revision feedback / reading and reacting to actual prose / weekly check-in?"

---

Adapt any of the above to the specific user. Skip or reorder rounds if the user gives rich answers that cover multiple rounds at once. Mark anything not covered as an "open gap" in profile.md.

## Don't

- Don't spawn without confirming the domain (avoid creating wrong-shaped coach)
- Don't skip the interview (the resulting coach is generic and useless)
- Don't ask all questions at once (one round at a time, per user's stated preference)
- Don't push the user — if they want to skip a round, mark it as "to fill in later"
- Don't create a coach with the same name as existing one without confirming overwrite
- Don't add the alias if it conflicts with an existing alias (e.g., `cook` is already a system command on some setups — check)
- **Don't write a coach `CLAUDE.md` with eager pre-reads** (e.g., "read 6 files before responding to ANY message"). That produces 30s+ latency on a "hi". Default to reading `context-snapshot.md` only at session start; lazy-load deeper files only when the conversation demands it. The Pole coach's CLAUDE.md is the legacy anti-pattern — don't copy it verbatim.
- **Don't skip creating/updating `.claude/drive-config.json`** (see step 5) — without it, the phone→Mac inbox sync silently breaks.

## Inputs

- User intent ("spawn cooking coach")
- Existing examples in framework
- Existing coaches (to avoid name collision)

## Outputs

- New coach folder fully populated
- Drive folder structure
- Updated zshrc
- Updated drive-config.json
- Initial snapshot in Drive
- Phone Claude.ai system prompt (printed to terminal for copy)

## After spawning

The skill suggests:
- "Open a new terminal and type `cook` to start your first session."
- "Set up the Claude.ai phone project with the system prompt I just printed."
- "Run `coach-evolve cook` after ~10 sessions to refine the coach."

## Why this matters

Manual coach creation is 30+ steps and easy to mess up. Spawn-coach makes it 10 min, repeatable, and stable. The friction of adding a coach is what determines whether you have 1 or 5 — keep the friction low.
