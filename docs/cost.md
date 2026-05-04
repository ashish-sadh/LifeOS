# Cost analysis

Honest accounting of what LifeOS costs to run. Prices are approximate as of May 2026 and change frequently — treat these as order-of-magnitude estimates, not quotes.

---

## TL;DR

| Usage pattern | Monthly estimate |
|---|---|
| Light (1-2 coaches, occasional sessions) | $5–15/month |
| Moderate (3-4 coaches, daily use) | $15–40/month |
| Heavy (5+ coaches, daily multi-coach, heavy research) | $40–100+/month |

Most users fall in the light-to-moderate range. The cost driver is how many tokens you push through Claude API in sessions.

---

## Component breakdown

### Claude API (or subscription)

The dominant cost. Three ways to pay:

**Option 1: Claude.ai subscription ($20/month for Max)**
- Covers unlimited Claude.ai phone sessions (with fair use)
- Does NOT cover Mac CLI usage (CLI = API calls)
- Good choice if you mostly use phone surface and want predictable billing

**Option 2: Claude API (pay-as-you-go)**
- Mac CLI sessions bill directly via API
- Typical 30-min coaching session: 5,000–15,000 tokens input + 1,000–3,000 output
  - At Sonnet 4: ~$0.50–$2.00 per session
  - At Haiku: ~$0.05–$0.20 per session (lighter, faster, less capable)
- Running the weekly research job (automated): ~10,000–25,000 tokens per coach
  - 3 coaches weekly = ~$1–3/week in research alone

**Option 3: Both**
- Max subscription for phone + API for Mac CLI
- Avoids phone rate limits while keeping Mac sessions flexible

**Context size matters**: coaches with large session histories or full vocabulary reads cost more per session. The lazy-load reading protocol (2 bootstrap files instead of 7) reduces per-session token spend by ~60–80% compared to the eager pattern.

### Google Drive

**Drive storage**: vault files are markdown text, tiny. A 1-year vault with 3 active coaches is typically under 5 MB — negligible against Drive's free 15 GB tier.

**Drive API**: the connector reads/writes files during Claude.ai phone sessions. The API has a generous free tier; typical vault usage stays well within it. No cost concern here.

**Drive Desktop**: free. Background daemon, no usage billing.

### Gemini (if using as a surface)

**Gemini Advanced ($20/month for Google One AI Premium)**: covers Gemini phone sessions with Drive integration. Equivalent to Claude Max subscription for the Gemini surface.

If you're already a Google One subscriber, you may have Gemini Advanced included.

### ChatGPT (if using as a surface)

**ChatGPT Plus ($20/month)**: required for Custom GPTs, which is how the ChatGPT surface works in LifeOS. Without Plus, no Custom GPTs.

### OpenClaw (if using)

OpenClaw is a local AI runner that can host open-source models on your Mac. It's free software, but running local models has energy/compute cost (your laptop's GPU/CPU). Not measurable as a dollar figure; it's a tradeoff of electricity for privacy and no-API-cost.

---

## Realistic scenarios

### Scenario A: Solo pole coach, occasional sessions (2-3x/week)

- Mac CLI sessions: 3 sessions/week × $1/session average = ~$12/month via API
- Or: Claude Max subscription covers phone sessions ($20/month flat)
- Drive: free
- **Total: ~$12–20/month**

### Scenario B: 3 active coaches (pole, cooking, thinking), daily use

- Mac CLI: 5 sessions/week across 3 coaches × $1.50 average = ~$30/month
- Automated research job: 3 coaches × $1.50/week = ~$18/month
- Phone sessions via Claude.ai Max: covered in the $20 subscription
- **Total: ~$50/month** (API for Mac + Max for phone)

### Scenario C: Heavy researcher, 5+ coaches, weekly research automated

- Mac CLI: high volume = $40–70/month via API
- Automated jobs: $20–40/month
- Phone: $20 Max subscription
- **Total: $80–130/month**

---

## Cost reduction strategies

**Use the lazy-load reading protocol**: the 2-file bootstrap pattern reads ~1,000 tokens vs. the 7-file eager pattern (~5,000 tokens) before the first response. On 100 sessions/month, that's ~400,000 fewer input tokens — roughly $2–8 saved/month depending on the model.

**Use Haiku for scheduled jobs**: the daily consolidation and weekly research jobs run unattended. Swap the CLI model for claude-haiku in these scripts to cut automated job costs by 5–10×. Quality may be slightly lower but these are synthesis jobs, not reasoning-intensive sessions.

**Keep context-snapshot.md compressed**: the 10 KB cap on snapshots reduces what phone Claude reads per session. `vault-maintain` will flag oversized snapshots.

**Batch sessions**: one 45-minute deep session costs roughly the same as three 15-minute sessions — fewer session-start overheads.

**Use Gemini for quick lookups**: if you're already paying for Google One AI Premium, using Gemini for short fact-checking sessions avoids Claude API charges for low-value interactions.

---

## What you're buying

The cost buys:
- A coach that accumulates months of domain knowledge about you specifically
- Cross-device access from any AI surface
- Automated weekly synthesis and research
- Self-improving personas that refine themselves based on what works for you

Compared to a real human coach ($80–200/session), the cost is dramatically lower while the availability, breadth, and personalization are different trade-offs — not comparable, but often complementary.
