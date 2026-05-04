# Why this exists

A short essay on why a framework like this is worth building, and why generic AI chatbots aren't enough.

---

## The problem with generic AI assistants

Open ChatGPT or Claude, ask "how do I improve at pole dance?" — you get advice that's true on average but not for you. It assumes a generic body, generic schedule, generic level. Within 5 minutes you stop using it because the advice is a Google search with extra steps.

Same with thinking, fitness, cooking, speaking. The advice is correct but interchangeable. You can't grow with it because it doesn't grow with you.

## The thing that's actually missing

A coach knows you. After 6 months with a real human coach, they:

- Know which moves you're scared of and why
- Remember which cues actually unlocked progress for you (not the textbook ones)
- Track your asymmetries, your injury patterns, your good and bad weeks
- Adapt their tone to what you respond to (some need encouragement; some need direct correction)
- Notice patterns you don't (you always plateau in week 4 of intensity blocks)

Generic AI can't do this because it has no memory of you. Even AI with "memory" features only remembers conversation excerpts; it doesn't have a structured model of you that compounds over time.

## What this framework adds

A coach with persistent, structured memory of you, accessible from any device.

- **Files** — your profile, body, training program, move vocabulary, session history are real markdown files you can read and edit
- **Domain-shaped** — pole's "moves" and cooking's "recipes" and thinking's "mental models" are different shapes; each coach gets a structure that fits its domain
- **Self-improving** — the coach reviews its own behavior periodically and refines its persona based on what works for you
- **Cross-device** — Mac for deep work, phone for quick conversations and capture, with shared vault
- **No lock-in** — markdown files outlive any app. If Anthropic disappears, you have a folder of human-readable notes about yourself.

## Why not just use Notion AI / Mem.ai / [other AI PKM]

Those are real products and might be better fits if you don't want to maintain a system yourself. Trade-offs:

| | This framework | Hosted AI PKM |
|---|---|---|
| Setup | ~30 min initial, ~10 min per coach | Sign up, type |
| Maintenance | Some (vault-maintain skill helps) | None |
| Lock-in | Zero (your data is markdown files) | Vendor-specific format |
| Customization | Full — write your own skills, restructure freely | Limited to their UI |
| Cost | ~$0/month (Claude API + free Drive) | $10-20/month typically |
| Offline | Mac CLI works offline | Usually requires connection |

Pick based on what you value. This framework is for people who want long-term ownership and customization, and don't mind 30 min of setup.

## Why Obsidian, not Notion?

Three reasons:
1. **Markdown files** — portable forever; works in any text editor
2. **No cloud lock-in** — your vault is on your hardware
3. **Plugin ecosystem** — semantic search, daily notes, graph view, all free

Notion has its strengths (databases, structured data) but those don't matter for personal coaching. Coaches want narrative, not tables.

## Why Claude, not GPT?

Mostly: this was built when Claude's tool-use and Drive connector were strongest. The framework would work with any AI that can read/write Markdown via a connector — replace the prompts and Drive folder IDs and you're 80% there. We're not religious about Claude.

## Why a coach per domain, not one general assistant?

Because expertise is domain-specific. A pole coach knows muscle anatomy of inversions; a cooking coach knows knife technique; a thinking coach knows mental models. Cramming all of that into one persona makes it generic again.

The vault root has a "meta" coach (`brain` alias) for cross-coach questions ("what's my pattern this week?"). Specialized coaches handle the deep work.

## What this *isn't*

- **Not a therapy app** — coaches help you train; they're not licensed mental health support
- **Not a diet/medical replacement** — a fitness coach can't replace a physical therapist; it can help you decide when to see one
- **Not a substitute for human teachers** — a pole coach learns from you and reflects patterns; it doesn't replace your studio instructor
- **Not magic** — you have to actually use it. Five minutes of typing into a vault doesn't replace 50 hours of real training.

## What it can be

A persistent, structured, growing model of your domain expertise that talks back to you in your own voice.

That's worth 30 minutes of setup.
