# Fitness Coach Example

Template for a strength and mobility coach. Use this as the starting point when spawning a `GetBetterAtFitness` coach.

## What's distinctive about this domain

- **Progressive overload tracking**: fitness value is in the longitudinal record — loads, reps, RPE over months, not just "I worked out."
- **Program structure**: unlike cooking or thinking, fitness work happens inside a block (4–8 weeks of structured progression). The program.md file is load-bearing.
- **Movement quality matters as much as load**: a heavier squat on a broken pattern is not progress. The coach tracks technique, not just numbers.
- **Recovery is half the training**: sleep, stress, and nutrition affect performance more than most programming choices. The coach needs to know recovery state.
- **Distinct from pole**: pole tracks move vocabulary, fear/confidence, artistry. Fitness tracks loads, volume, progressive overload, body metrics. The overlap (physical capacity, injury management) is handled differently.

## Distinctive folder structure

```
Coaches/GetBetterAtFitness/
├── CLAUDE.md
├── profile.md
├── program.md                   Current training block (week-by-week)
├── workouts/                    Individual session logs
│   ├── 2026-09-15-lower-body.md
│   ├── 2026-09-17-upper-body.md
│   └── ...
├── metrics/                     Long-term tracking
│   ├── strength-benchmarks.md   1RM / e1RM history per lift
│   └── body-metrics.md          Optional: weight, measurements, photos
├── progressions/                Movement development (optional, when needed)
│   ├── squat.md
│   └── deadlift.md
├── sessions.md                  Coach conversations
└── context-snapshot.md
```

## What to seed when spawning

The `spawn-coach` skill will ask:

1. What is your primary goal right now?
   - Strength (get stronger at key lifts)
   - Hypertrophy (muscle growth)
   - General fitness (health, capacity, feel good)
   - Recomposition (strength + body composition)
   - Sport prep (supporting another sport)
2. Training age — how many years of structured training?
3. Equipment available (barbell, rack, dumbbells, machines, home, gym)?
4. Days per week and time per session?
5. Current strength baseline — any idea of your squat / deadlift / bench / press?
6. Mobility issues or injury history that constrain programming?
7. What's your "white whale" lift or movement — the thing you want to own?

## Workout log format

```markdown
# YYYY-MM-DD — [Session Type] (Week N, Block N)

**Duration**: X min
**Overall RPE**: X/10
**Recovery going in**: X/10

## Main work

### [Exercise name]

| Set | Weight | Reps | RPE | Notes |
|---|---|---|---|---|
| 1 | Xkg | Y | Z | |

**Notes**: [technique observations, how it felt, what to do next session]
**Target next session**: [specific load and reps]
```

This format lets the coach read session logs and make precise load recommendations. Without sets/reps/RPE, recommendations are generic.

## Progression model

The coach tracks progression at two levels:

1. **Short-term**: session-to-session load progression (add 2.5 kg when RPE ≤ 7, hold when RPE = 8, deload when RPE = 9+)
2. **Long-term**: block-to-block benchmark comparison (strength-benchmarks.md)

When a lift stalls for 3+ consecutive sessions, the coach diagnoses root cause before prescribing changes.

## Tips

1. **Log sessions the same day**. Next-day memory of loads and RPE is unreliable.
2. **Use RPE honestly**. RPE 8 = 2 reps left in the tank. If you regularly log RPE 7 and fail sets, your RPE calibration is off — tell the coach.
3. **The program.md is the coach's primary tool**. Keep it current. If life disrupts the plan, update program.md — don't just skip ahead.
4. **Mobility work is part of training, not optional extra**. If a pattern is limiting, it belongs in the session, not "after I finish the real workout."
