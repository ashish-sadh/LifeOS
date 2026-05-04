#!/usr/bin/env bash
# Weekly Sunday 9am: cross-coach review of past 7 days
#
# Stamp guard: Sundays only, after 09:00, once per Sunday.

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
LOG_DIR="$HOME/.cache/lifeos-logs"
STAMP="$LOG_DIR/weekly-review.stamp"
LOG="$LOG_DIR/weekly-review.log"

mkdir -p "$LOG_DIR" "$LIFEOS/proposals"

TARGET_HOUR=9
DOW=$(date +%u)  # 1=Mon, 7=Sun
TODAY=$(date +%Y-%m-%d)
HOUR=$(date +%H | sed 's/^0//')
LAST=$(cat "$STAMP" 2>/dev/null || echo "")

[ "$DOW" -ne 7 ] && exit 0
[ "$LAST" = "$TODAY" ] && exit 0
[ "$HOUR" -lt "$TARGET_HOUR" ] && exit 0

DATE="$TODAY"
OUTPUT="$LIFEOS/proposals/$DATE-weekly-review.md"

cd "$LIFEOS"

claude --dangerously-skip-permissions --print "
Run the weekly-review skill (.claude/skills/weekly-review/SKILL.md).

Output to: $OUTPUT

Read past 7 days from each active coach's sessions.md, all Daily/ entries, recent Inbox.md additions, all phone-written inbox files. Synthesize per the skill's instructions.

Be concise. The user reads this Sunday morning in 5 min.
" >> "$LOG" 2>&1

echo "$TODAY" > "$STAMP"
