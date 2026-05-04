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
   - Update `Vault/.claude/drive-config.json` with new folder IDs

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

Adapt rounds to domain. For pole the rounds are different (move inventory, body history, asymmetries, training cadence, session rhythm).

## Don't

- Don't spawn without confirming the domain (avoid creating wrong-shaped coach)
- Don't skip the interview (the resulting coach is generic and useless)
- Don't ask all questions at once (one round at a time, per user's stated preference)
- Don't push the user — if they want to skip a round, mark it as "to fill in later"
- Don't create a coach with the same name as existing one without confirming overwrite
- Don't add the alias if it conflicts with an existing alias (e.g., `cook` is already a system command on some setups — check)

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
