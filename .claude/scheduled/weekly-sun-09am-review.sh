#!/usr/bin/env bash
# Weekly Sunday 9am: cross-coach review of past 7 days

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
DATE=$(date +%Y-%m-%d)
OUTPUT="$LIFEOS/proposals/$DATE-weekly-review.md"
LOG="$HOME/.cache/lifeos-logs/weekly-review.log"

mkdir -p "$(dirname "$LOG")" "$LIFEOS/proposals"

cd "$LIFEOS"

claude --dangerously-skip-permissions --print "
Run the weekly-review skill (.claude/skills/weekly-review/SKILL.md).

Output to: $OUTPUT

Read past 7 days from each active coach's sessions.md, all Daily/ entries, recent Inbox.md additions, all phone-written inbox files. Synthesize per the skill's instructions.

Be concise. The user reads this Sunday morning in 5 min.
" > "$LOG" 2>&1
