# Cross-domain intelligence — worked examples

The most underappreciated part of LifeOS is not any individual coach. It's the moments when two or three coaches share a context they couldn't have individually.

This document shows those moments concretely.

---

## Example 1: Sleep + pole performance

**Files involved**:
- `_shared/profile.md` — sleep quality field updated
- `Coaches/GetBetterAtPole/profile.md` — asymmetry and energy notes
- `Coaches/GetBetterAtFitness/profile.md` — recovery tracking

**What happened**:

The pole coach, reading `_shared/profile.md` at session start, notices: "sleep quality: 4–5/10 this week (chronic)." The coach knows from pole session history that two consecutive bad-sleep weeks correlate with asymmetry flare — the left shoulder grip weakens first.

Before the session, the coach opens with:
> *"Sleep's still low this week. Your left shoulder grip typically degrades first when you're running a sleep deficit. Worth doing the assisted shoulder prep drill before jumping to inverts. I'd dial back the full shoulder mount attempts until you've had 2+ nights above 7 hours."*

The user didn't ask about sleep. They didn't ask to connect sleep to pole. The system did it because the pole coach reads `_shared/profile.md` before every session, and the fitness coach (or the user) updated it after a check-in.

**The cross-domain mechanics**:
1. Fitness coach writes to `_shared/profile.md`: "sleep quality update: averaging 5/10, cause: work deadline this week"
2. Pole coach reads `_shared/profile.md` at session start
3. Pole coach's `profile.md` contains a documented correlation: "sleep deficit → left grip asymmetry flares"
4. Pole coach surfaces the connection unprompted

Without `_shared/profile.md` as a shared substrate, the pole coach never sees the sleep data. The two domains stay isolated.

---

## Example 2: A restaurant visit informs the cooking coach

**Files involved**:
- `Restaurants/sf/shizen.md` — restaurant note with specific dish observations
- `Coaches/GetBetterAtCooking/sessions.md` — referenced in next cooking session
- `Coaches/GetBetterAtCooking/vocabulary.md` — technique added

**What happened**:

The user has dinner at Shizen (a vegan omakase in SF) and notes in `Inbox.md`:
> *"Shizen 2026-04-22: the eggplant dish was unlike anything — somehow achieved the texture of fatty fish. Very slow-roasted? The yuzu glaze was barely-there but present. The contrast made the umami readable."*

`inbox-triage` routes this to `Restaurants/sf/shizen.md`. At the next cooking session, the cooking coach reads `_shared/profile.md` and `Coaches/GetBetterAtCooking/sessions.md`, which cross-links to the restaurant note. The coach can now reference the meal:

> *"You had that eggplant dish at Shizen last week — the one you described as 'fatty fish texture.' That's almost certainly a long Maillard + steam-convection process: high heat for crust, then wrapped in foil with moisture to finish. The yuzu landing 'barely-there but present' is a finishing acid, added after plating, not cooked in. Want to try a version this week? I'd start with Japanese eggplant, not globe."*

The cooking coach didn't need to be at the dinner. It just needed to read a file the user wrote afterward.

**The cross-domain mechanics**:
1. User captures observation in `Inbox.md`
2. `inbox-triage` routes it to `Restaurants/sf/shizen.md` and adds a wikilink from the user's cooking profile note
3. Cooking coach reads the linked restaurant note during session prep
4. Cooking coach connects the sensory observation to a technical explanation

---

## Example 3: Thinking coach + fitness decision

**Files involved**:
- `Coaches/GetBetterAtThinking/decisions/2026-05-01-injury-protocol.md`
- `Coaches/GetBetterAtFitness/profile.md`
- `_shared/profile.md` — injury status field

**What happened**:

User is weighing whether to train through mild knee pain or rest. They bring it to the thinking coach, not the fitness coach, because it feels like a decision problem (risk tolerance, short vs. long-term, evidence under uncertainty). The thinking coach helps them apply a pre-mortem:

> *"Imagine it's 3 months from now and the knee is significantly worse. What did you do in the next week that caused it? Probably: kept training, ignored the signal, rationalized 'it's not that bad.' Now: what would the cautious version of you do? 3-day rest, ice, elevation. What do you lose? One week of training. What do you gain? Ruled out anything structural."*

The decision journal captures the output: "Rest 3 days. Ice. See physio if not resolved."

The fitness coach, reading `Coaches/GetBetterAtThinking/decisions/` as part of weekly context (or when explicitly referenced), picks this up:

> *"You decided to rest the knee after the thinking-coach pre-mortem last week. Did 3 days help? I want to update your injury pattern in the fitness profile — this is the second time this year where a minor knee flare escalated into a week-long rest instead of 3 days catching it early. Worth building in a 'stop at first signal' rule."*

**The cross-domain mechanics**:
1. Thinking coach writes to `decisions/2026-05-01-injury-protocol.md` with the decision and reasoning
2. Fitness coach reads the decisions folder (or the user mentions it) at next session
3. Fitness coach connects the decision outcome to a pattern in the training profile
4. Pattern gets written to `Coaches/GetBetterAtFitness/profile.md` as "stop-at-first-knee-signal rule"

---

## Example 4: People + Events + Coach

**Files involved**:
- `People/sarah-instructor.md` — pole instructor, specific feedback documented
- `Events/2026-04-28-showcase.md` — performance event
- `Coaches/GetBetterAtPole/sessions.md` — post-showcase debrief

**What happened**:

User performs at a showcase. Afterward, instructor Sarah gives specific feedback: "Your left shoulder is internally rotating on the way into the crucifix. You're compensating with your lat. It's stable but it's limiting your range."

The user writes this to `People/sarah-instructor.md` in the feedback section, and to `Events/2026-04-28-showcase.md` in the takeaways. The vault is now holding the feedback in two places.

At the next Mac pole session:
> *"I saw the event note from the showcase — Sarah flagged internal shoulder rotation on the crucifix entry. I already have this in your profile as a mild asymmetry. What I didn't have is the compensation pattern: you're lat-dominant, not externally rotating the shoulder first. That's the root cause of why your shoulder mount entries have been 'technically fine but never crisp.' I'd add 2 sets of band pull-aparts to your warmup — specifically external rotation emphasis — and consciously cue 'pack and rotate before the pull' on every crucifix for the next 4 weeks."*

The coach synthesized: the profile's existing asymmetry note + the new instructor feedback + the demonstrated compensation pattern → a specific intervention.

**The cross-domain mechanics**:
1. User writes instructor feedback to `People/sarah-instructor.md` and `Events/2026-04-28-showcase.md`
2. `cross-domain-link` adds wikilinks between the event, the person, and the pole coach folder
3. Pole coach reads linked notes as relevant context
4. Coach synthesizes existing profile knowledge with new feedback to produce a targeted fix

---

## The pattern

In every example, the same mechanics are at work:

1. **`_shared/profile.md` as a broadcast bus** — anything relevant to multiple coaches lives there; every coach reads it at session start
2. **Inbox.md as a capture point** — raw observations land in inbox; `inbox-triage` routes them to the right permanent home
3. **Cross-domain links as retrieval paths** — wikilinks between People, Events, Restaurants, and coach files make related context discoverable
4. **Append-only accumulation** — nothing is overwritten; patterns emerge over time as coaches read more history

The intelligence isn't in any single file. It's in the traversal: coach reads profile → profile references restaurant note → restaurant note references event → event references person → person file has instructor feedback → instructor feedback informs the next training intervention.

That traversal is manual for a human coach trying to connect dots across your life. For LifeOS coaches, it's just file reads.

---

## How to make your vault more cross-domain-intelligent

1. **Keep `_shared/profile.md` current** — update energy, sleep, stress, and schedule there, not just in individual coach profiles. Every coach reads it.

2. **Capture observations in Inbox.md without worrying about routing** — the `inbox-triage` skill handles routing. Capture everything; route periodically.

3. **Run `cross-domain-link` after inbox-triage** — let the system propose links between newly routed files and existing vault content.

4. **Mention relevant cross-domain observations in sessions** — if your pole session is affected by poor sleep, say "I've been sleeping badly this week." The coach writes it to your profile. The next coach who reads the profile sees it.

5. **Use the `brain` alias for cross-domain questions** — the vault root coach reads across all coaches and is specifically designed for synthesis questions: "What's my pattern this week?", "How are my goals aligning across domains?", "Is there anything I should tell my fitness coach about pole?"
