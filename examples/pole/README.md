# Pole Dance Coach Example

Sanitized template for a pole dance coach. Use this as the starting point when spawning a `GetBetterAtPole` coach.

## What's distinctive about this domain

- **Move-based vocabulary**: each move (chopper, butterfly, shoulder mount) gets a definition with muscles, prerequisites, and failure modes.
- **Asymmetry tracking**: pole is brutally honest about right/left differences. Track per move.
- **Injury vulnerability tracking**: trap, wrist, shoulder are common hot spots. Track and design conditioning around them.
- **Progressions matter**: shoulder mount, handspring, etc. take 4+ weeks of structured progression. Track per-move.
- **Body composition + grip + skin**: bruising, hand sweat, calluses all affect what you can practice each day.

## Files in this example

- `CLAUDE.md` — Pole coach persona, reading/update protocols, voice
- `profile.md` — Template for pole-specific user state
- `vocabulary.md` — 7 seed move definitions to start with (chopper, crucifix, inside/outside leg hang, butterfly, climbing, shoulder mount)

Add as you grow:
- `program.md` — your current training program
- `sessions.md` — append-only training log
- `context-snapshot.md` — phone-ready digest (regenerated automatically)
- `progressions/<move>.md` — deep-dive tracking for specific multi-week skills
- `anatomy-reference.md` — muscle group reference

## Tips

1. **Always train left side first** (or whichever is your weaker side). Pole's asymmetry rule.
2. **Don't push pain points** — back off and condition around them. Trap/wrist flares are common; treat as signals.
3. **Track grip variety** — relying only on cup grip burns out wrist/forearm; rotate baseball, split, twisted.
4. **Climbing transfers strongly** — if you climb, your pulling chain is your asset. Lean into it for inverts and holds.
