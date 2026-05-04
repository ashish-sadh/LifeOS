#!/usr/bin/env bash
# Daily 8am morning brief
# Reads calendar (when integrated), people (birthdays), each active coach's recent state.
# Writes synthesis to LifeOS/proposals/<date>-morning-brief.md

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
DATE=$(date +%Y-%m-%d)
OUTPUT="$LIFEOS/proposals/$DATE-morning-brief.md"
LOG="$HOME/.cache/lifeos-logs/morning-brief.log"

mkdir -p "$(dirname "$LOG")" "$LIFEOS/proposals"

cd "$LIFEOS"

claude --dangerously-skip-permissions --print "
Generate today's morning brief.

Read in this order:
1. _shared/profile.md (user context)
2. _shared/principles.md
3. _system/architecture.md (just first 50 lines for system orientation)
4. People/*.md frontmatter — find any birthdays in next 14 days
5. Events/upcoming.md — find events in next 7 days
6. Assistant/tasks.md, Assistant/reminders.md, Assistant/waiting-for.md (current state)
7. For each active coach (folders in GetBetterAt/): read context-snapshot.md and last 3 entries of sessions.md

Compose a concise morning brief in this format:

# Morning Brief — $DATE

## Today
(if Calendar connector available, list today's events; otherwise note 'no calendar context yet')

## Upcoming this week
- Birthdays: <list with dates>
- Events: <list>
- Reminders coming due: <list>

## Active to-dos summary
<2-3 most important items from tasks.md, NOT the whole list>

## Stale waiting-for
<items in waiting-for.md > 7 days old>

## Coach pulse (per active coach, 1 line each)
- Pole: <current edge + last session takeaway>
- (other coaches if active)

## Suggested today
<2-3 specific suggestions based on calendar gaps + coach priorities>

Save the output to: $OUTPUT

Be brief. The user reads this in 2 minutes. No filler.
" > "$LOG" 2>&1
