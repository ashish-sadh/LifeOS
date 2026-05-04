# Contributing

Welcome. This is a young framework; contributions are very welcome.

## What to contribute

- **New coach domain templates** — cooking, writing, parenting, woodworking, language learning, etc. Each lives in `examples/<domain>/`.
- **New skills** — workflows that all coaches can use. Each lives in `skills/<name>/SKILL.md`.
- **Architecture improvements** — better ways to handle phone↔Mac sync, faster snapshots, smarter cleanup.
- **Documentation** — clarification, missing topics, examples.
- **Bug reports + use case feedback** — issues are welcome.

## Ground rules

### Personal data must never appear in this repo

This is a public framework, not a personal vault. **No real profile.md, sessions.md, vocabulary.md, drive-config.json, or daily notes.** The `.gitignore` enforces this; double-check before pushing.

If you want to share a real coach example, sanitize first:
- Replace personal facts with placeholders (`<your-name>`, `<your-injuries>`, etc.)
- Replace real Drive folder IDs with `<DRIVE_FOLDER_ID>`
- Replace real session entries with realistic-but-fake examples

### Keep the framework markdown-first

The whole point is portability and human-readability. If you're tempted to introduce a database, binary format, or complex toolchain, ask first whether markdown + simple shell scripts could do the job.

### Match existing conventions

- Skills follow the `SKILL.md` format with frontmatter (`name`, `description`)
- Coach folders follow the `Coaches/GetBetterAt<Name>/` pattern
- Shell aliases follow the short verb pattern (`pole`, `cook`, `think`)
- File-naming uses ISO timestamps and kebab-case where applicable
- Markdown headers use sentence case unless quoting

### Two voice rules

- **Coach files speak to the user** as a coach (direct, technically precise, encouraging without coddling). Read `examples/pole/` for tone.
- **Framework docs speak to the developer** (clear, occasionally direct, no fluff). Read this file's tone.

Don't mix.

## How to contribute

1. **Fork the repo**
2. **Branch** from `main`: `git checkout -b feature/<short-name>`
3. **Make your changes**:
   - For new skills: add `skills/<name>/SKILL.md`
   - For new coach templates: add `examples/<domain>/` with sanitized files
   - For docs: edit existing `.md` files or add to `docs/`
4. **Test** that your additions don't break existing skills (run a real Mac CLI session if you can)
5. **Open a PR** with:
   - What you added
   - Why it's useful
   - Any caveats / known limitations

## Coach template checklist

If adding a new domain coach to `examples/<domain>/`:

- [ ] `CLAUDE.md` — coach persona + protocol
- [ ] `profile.md` — domain-specific user state template (with placeholders)
- [ ] `program.md` — example structure for whatever the domain's progression is
- [ ] `vocabulary.md` (or domain equivalent like `recipes/`, `decisions/`, etc.)
- [ ] `sessions.md` — session log format
- [ ] `context-snapshot.md` — phone-ready digest template
- [ ] Any domain-specific subdirectories (e.g., `recipes/` for cooking, `progressions/` for skill-based)
- [ ] README in the example folder explaining what's unique about this domain

## Skill template checklist

If adding a new skill to `skills/<name>/SKILL.md`:

- [ ] Frontmatter: `name`, `description`
- [ ] Section: When to invoke
- [ ] Section: What it does (algorithm)
- [ ] Section: Inputs / outputs
- [ ] Section: Don't (anti-patterns)
- [ ] Optional: example invocations from real conversations

## Code of conduct

Be kind. Disagree on substance, not on people. If you wouldn't say it to someone face-to-face in the same tone, rewrite.

## License

By contributing, you agree your contributions will be licensed under the MIT License.
