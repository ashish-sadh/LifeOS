#!/usr/bin/env bash
# Daily 11pm: consolidate inbox files for each active coach into days/<date>.md
#
# Fires from launchd at 23:00, on agent reload (RunAtLoad), and hourly (StartInterval).
# A stamp file ensures we run at most once per target date.
# - At/after 23:00 → consolidate today.
# - Earlier in the day with no stamp for yesterday → catch up yesterday (laptop was off at 23:00).
# - Otherwise → exit silently.

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
LOG_DIR="$HOME/.cache/lifeos-logs"
STAMP="$LOG_DIR/daily-consolidate.stamp"
LOG="$LOG_DIR/daily-consolidate.log"

mkdir -p "$LOG_DIR"

TARGET_HOUR=23
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d)
HOUR=$(date +%H | sed 's/^0//')
LAST=$(cat "$STAMP" 2>/dev/null || echo "")

if [ "$LAST" = "$TODAY" ]; then
    exit 0
elif [ "$HOUR" -ge "$TARGET_HOUR" ]; then
    DATE_TO_RUN="$TODAY"
elif [ "$LAST" != "$YESTERDAY" ]; then
    DATE_TO_RUN="$YESTERDAY"
else
    exit 0
fi

cd "$LIFEOS"

claude --dangerously-skip-permissions --print "
Run the daily-consolidate skill (.claude/skills/daily-consolidate/SKILL.md) for date $DATE_TO_RUN.

For each active coach folder in GetBetterAt/:
- Find inbox files dated $DATE_TO_RUN
- If 1+ exist, synthesize into GetBetterAt/<coach>/days/$DATE_TO_RUN.md per the skill's template
- If zero exist for a coach, skip it

Don't delete the source inbox files (we'll do that during vault-maintain). Just produce the consolidation.

After consolidation, also run vault-push-snapshot for each coach that had activity on $DATE_TO_RUN, so phone has fresh context.
" >> "$LOG" 2>&1

echo "$DATE_TO_RUN" > "$STAMP"
