#!/usr/bin/env bash
# Weekly Sunday 10am: per-coach research
# Each active coach searches the web for new info in its domain, cross-references with user state, proposes additions.
#
# Stamp guard: Sundays only, after 10:00, once per Sunday.

set -euo pipefail

LIFEOS="$HOME/Library/CloudStorage/GoogleDrive-asheesh.sadh@gmail.com/My Drive/LifeOS"
LOG_DIR="$HOME/.cache/lifeos-logs"
STAMP="$LOG_DIR/weekly-research.stamp"
LOG="$LOG_DIR/weekly-research.log"

mkdir -p "$LOG_DIR" "$LIFEOS/proposals"

TARGET_HOUR=10
DOW=$(date +%u)
TODAY=$(date +%Y-%m-%d)
HOUR=$(date +%H | sed 's/^0//')
LAST=$(cat "$STAMP" 2>/dev/null || echo "")

[ "$DOW" -ne 7 ] && exit 0
[ "$LAST" = "$TODAY" ] && exit 0
[ "$HOUR" -lt "$TARGET_HOUR" ] && exit 0

DATE="$TODAY"

cd "$LIFEOS"

COACHES=$(ls -d "$LIFEOS/GetBetterAt/"*/ 2>/dev/null | xargs -n1 basename)

for COACH in $COACHES; do
    OUTPUT="$LIFEOS/proposals/$DATE-research-$COACH.md"
    echo "Researching for coach: $COACH" >> "$LOG"

    claude --dangerously-skip-permissions --print "
You are researching new information for the $COACH coach this week.

1. Read GetBetterAt/$COACH/CLAUDE.md (your persona)
2. Read GetBetterAt/$COACH/profile.md (user state)
3. Read GetBetterAt/$COACH/program.md (current focus)
4. Read GetBetterAt/$COACH/vocabulary.md (what's already known)
5. Read last 5 entries of GetBetterAt/$COACH/sessions.md (recent context)

Then use WebSearch to find:
- New techniques, moves, or methods relevant to this coach's domain
- Filter for level (match user's current level — not too beginner, not too advanced)
- Filter for relevance to current focus (e.g., if user is working on shoulder mount, prioritize that)
- Filter for user's vulnerabilities (don't suggest things that would aggravate known injuries)
- Avoid things already in vocabulary.md

Compose a research report at $OUTPUT with this structure:

# $COACH — Weekly Research, $DATE

## Summary
<one paragraph: what's worth user's attention this week>

## Findings (max 3-5)

### Finding 1: <Title>
Source: <URL>
Why this is for you: <connection to user's specific state>
Suggested action: <add to vocabulary / try in next session / discuss with instructor>
Confidence: <high / medium / low>

### Finding 2: <Title>
...

## Skipped
<things you considered but rejected, with brief reason>

## See also
<related notes already in vocabulary or progressions>

Be selective. Better 2 high-quality findings than 5 mediocre ones.
" >> "$LOG.coach-$COACH" 2>&1
done

echo "Weekly research complete for: $COACHES" >> "$LOG"
echo "$TODAY" > "$STAMP"
