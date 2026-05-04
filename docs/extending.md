# Extending the framework

How to add new coaches, skills, and capabilities to your vault. Whether you're customizing for yourself or contributing to the public framework.

---

## Adding a new coach (existing domain)

If a coach for your domain already exists in `examples/`:

1. From your terminal: `brain` → "spawn a [domain] coach"
2. The `spawn-coach` skill will copy the example template, customize it, and run the onboarding interview

Or manually:

```bash
cp -r ~/.GetBetterAt/examples/cooking $VAULT/Coaches/GetBetterAtCooking
# Edit the files to add your specifics
# Add the alias to ~/.zshrc:
# alias cook='cd "$VAULT/Coaches/GetBetterAtCooking" && claude --dangerously-skip-permissions'
```

## Adding a new domain template

If your domain isn't in `examples/`:

1. Pick a similar example (pole for physical, cooking for creative, thinking for cognitive) and copy it
2. Adapt for your domain:
   - Replace `vocabulary.md` with whatever shape fits (`recipes/`, `decisions/`, `progressions/`)
   - Replace `program.md`'s training-block structure with your domain's progression model
   - Update `CLAUDE.md` persona for the domain (cooking coach != pole coach)
3. Test it for a week
4. (Optional) PR to public framework if generally useful

### Domain shapes that have worked

| Domain | Coach name | Distinctive folders |
|---|---|---|
| Physical (pole, fitness) | `GetBetterAtPole` | `progressions/`, vocabulary by category |
| Creative (cooking, writing) | `GetBetterAtCooking` | `recipes/`, `techniques/`, `learnings.md` |
| Cognitive (thinking, decisions) | `GetBetterAtThinking` | `decisions/`, `models/`, `journal/`, `predictions/` |
| Social (speaking, relationships) | `GetBetterAtSpeaking` | `talks/`, `feedback/`, `themes/` |
| Logistical (organized, finance) | `GetMoreOrganized` | `routines/`, `systems/`, `metrics/` |

The pattern: invariants are `CLAUDE.md`, `profile.md`, `sessions.md`, `context-snapshot.md`. Everything else is domain-shaped.

## Writing a new skill

Skills are markdown files at `.claude/skills/<name>/SKILL.md`. Format:

```markdown
---
name: my-skill
description: One-line description of when this skill triggers and what it does
---

# Skill: my-skill

## When to invoke
- Trigger conditions

## What to do
1. Step-by-step algorithm

## Inputs
- What the skill reads

## Outputs
- What the skill produces

## Don't
- Anti-patterns to avoid
```

Claude Code auto-discovers skills in `.claude/skills/`. You don't have to register them.

### Good skills are:

- **Composable** — invoke other skills as substeps
- **Idempotent** — safe to run multiple times
- **Conservative** — propose changes, get confirmation, then act
- **Domain-agnostic** — operate on any coach, not just one
- **Well-named** — the `name` field tells Claude when to invoke

### Skill ideas worth building

- `voice-memo-import` — Mac watches a folder for voice memos, transcribes, files into Inbox or coach inbox
- `cross-coach-pattern` — finds patterns across coaches (e.g., "tired weeks" appearing in multiple coaches)
- `partner-sync` — for couples sharing a fitness coach
- `instructor-import` — pull notes from your studio's app or email
- `progress-photo` — for fitness/pole; track image-based progression

## Customizing your shell aliases

Default aliases (added by bootstrap):

```bash
alias pole='cd "$VAULT/Coaches/GetBetterAtPole" && claude --dangerously-skip-permissions'
alias think='cd "$VAULT/Coaches/GetBetterAtThinking" && claude --dangerously-skip-permissions'
alias fit='cd "$VAULT/Coaches/GetBetterAtFitness" && claude --dangerously-skip-permissions'
# ...
alias brain='cd "$VAULT" && claude --dangerously-skip-permissions'
```

Customize as you like. Some prefer:
- `coach <name>` — single command with subcommand
- `c.<name>` — namespace prefix
- Long names (`pole-coach`, `fitness-coach`) for tab-completion clarity
- Different flags (`--no-dangerously-skip-permissions` if you want confirmation prompts)

## Customizing your CLAUDE.md files

Each coach's `CLAUDE.md` defines its persona and protocol. Edit freely:

- Adjust voice (more direct, more encouraging, more academic)
- Add custom reading order (e.g., "always read `motivations.md` first")
- Add custom update protocols (e.g., "rate every session 1-10 in `sessions.md`")
- Add cross-coach references ("if user mentions cooking, suggest the cooking coach")

The `coach-meta-review` skill runs quarterly and proposes its own edits to `CLAUDE.md` based on actual session data. You can run it manually any time: `pole` → "run coach-meta-review on yourself."

## Customizing the snapshot template

Snapshots are what phone Claude reads. The format is in `vault-push-snapshot/SKILL.md`. Customize if you want:

- Different sections
- Different compression strategy (more vocabulary, fewer sessions)
- Domain-specific templates (cooking snapshots include pantry list; pole snapshots include current shoulder mount progression)

The skill template uses Markdown sections; modify the assembly logic in the skill.

## Adding a non-Claude AI backend

The framework is Claude-centric (Anthropic's tool-use, Drive connector, Claude Code CLI), but you could adapt it:

- **OpenAI**: Replace `/mcp` with a custom MCP server pointing at OpenAI; use GPT-4's tool-use for Drive ops
- **Local LLM**: Use [llamafile](https://github.com/Mozilla-Ocho/llamafile) or Ollama with function-calling; replace Drive connector with rclone or local sync
- **Multiple AIs**: Mac CLI uses Claude; phone uses GPT — same vault, different reasoners

Caveats:
- Tool-use quality matters. Weaker models forget to read files.
- Drive connector specifically is Anthropic-shipped. Other AIs need their own integration.
- Most of the prompt structure transfers; specific tool names don't.

If you do this, contribute back — the framework would benefit from being multi-AI.

## Contributing back

If your customization seems generally useful:

1. Sanitize (remove personal data)
2. Test on a fresh vault clone
3. PR to https://github.com/ashish-sadh/GetBetterAt
4. See `CONTRIBUTING.md` for conventions
