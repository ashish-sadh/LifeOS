# Scheduled Background Work

Shell scripts triggered by launchd at scheduled times. They invoke `claude --print` non-interactively to produce work that the user reviews later via the `proposals/` folder.

## Scripts

| Script | Schedule | Output |
|---|---|---|
| `daily-08am-brief.sh` | Daily 8am | `proposals/<date>-morning-brief.md` |
| `daily-11pm-consolidate.sh` | Daily 11pm | `GetBetterAt/<coach>/days/<date>.md` per active coach |
| `weekly-sun-09am-review.sh` | Sun 9am | `proposals/<date>-weekly-review.md` |
| `weekly-sun-10am-research.sh` | Sun 10am | `proposals/<date>-research-<coach>.md` per active coach |
| `biweekly-sun-11am-maintain.sh` | Bi-weekly Sun 11am | `proposals/<date>-vault-maintain.md` |
| `monthly-01-audit.sh` | Monthly 1st 12am | `proposals/<date>-vault-audit.md` |
| `quarterly-01-meta-review.sh` | Quarterly 1st | `proposals/<date>-meta-review-<coach>.md` |

## How to enable

```bash
# Copy plists to LaunchAgents
cp $LIFEOS/.claude/scheduled/launchd/*.plist ~/Library/LaunchAgents/

# Load them
launchctl load ~/Library/LaunchAgents/com.lifeos.*.plist

# Verify
launchctl list | grep lifeos
```

## How to disable / pause

```bash
launchctl unload ~/Library/LaunchAgents/com.lifeos.*.plist
```

## Logs

`~/.cache/lifeos-logs/<job>.log` and `<job>.err`

## Mac sleep handling

launchd jobs only run when Mac is awake. For overnight jobs (11pm consolidate, 12am monthly audit), set Mac wake schedule in System Settings → Battery → Schedule.

For daytime jobs, Mac is usually awake.

## API cost note

Each scheduled run uses Claude API tokens. With Claude Max subscription, runs use your existing quota. Approximate monthly cost in tokens (per active coach):
- Daily brief: ~5K input + 1K output = ~$3/mo per coach (API price)
- Weekly research: ~15K input + 3K output = ~$2/mo per coach
- Monthly audit: ~20K + 3K = ~$0.30/mo

Total for 2 active coaches: ~$10-15/mo on API; included in Claude Max if quota holds.
