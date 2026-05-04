#!/usr/bin/env bash
# Daily 11pm: consolidate today's inbox files for each active coach into days/<date>.md

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
DATE=$(date +%Y-%m-%d)
LOG="$HOME/.cache/lifeos-logs/daily-consolidate.log"

mkdir -p "$(dirname "$LOG")"

cd "$LIFEOS"

claude --dangerously-skip-permissions --print "
Run the daily-consolidate skill (.claude/skills/daily-consolidate/SKILL.md) for today's date ($DATE).

For each active coach folder in GetBetterAt/:
- Find inbox files dated today
- If 1+ exist, synthesize into GetBetterAt/<coach>/days/$DATE.md per the skill's template
- If zero exist for a coach, skip it

Don't delete the source inbox files (we'll do that during vault-maintain). Just produce the consolidation.

After consolidation, also run vault-push-snapshot for each coach that had activity today, so phone has fresh context for tomorrow.
" > "$LOG" 2>&1
